Return-Path: <linux-kernel-owner+w=401wt.eu-S1752168AbZIGI2Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752168AbZIGI2Q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Sep 2009 04:28:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751687AbZIGI2P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Sep 2009 04:28:15 -0400
Received: from cantor2.suse.de ([195.135.220.15]:37156 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751627AbZIGI2O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Sep 2009 04:28:14 -0400
Date: Mon, 7 Sep 2009 10:28:15 +0200
From: Michal Hocko <mhocko@suse.cz>
To: Ingo Molnar <mingo@redhat.com>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org,
       "H . Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       Jiri Kosina <jkosina@suse.cz>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH v2] x86: increase MIN_GAP to include randomized stack
Message-ID: <20090907082815.GA12212@tiehlicka.suse.cz>
References: <1252057020-5207-1-git-send-email-mhocko@suse.cz>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="9amGYk9869ThD9tj"
Content-Disposition: inline
In-Reply-To: <1252057020-5207-1-git-send-email-mhocko@suse.cz>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--9amGYk9869ThD9tj
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri 04-09-09 11:37:00, Michal Hocko wrote:
> Currently we are not including randomized stack size when calculating
> mmap_base address in arch_pick_mmap_layout for topdown case. This might
> cause that mmap_base starts in the stack reserved area because stack is
> randomized by 1GB for 64b (8MB for 32b) and the minimum gap is 128MB.

Just for reference, attached you can find simple reproduction program
(which has been attached to our original bug report which unfortunately I
cannot make public). 

It prints memory layout when maximum mmaped address is too close to the
stack top. I understand that stack_top (as read from /proc/<PID>/stat)
is not the best choice because it doesn't include auxv, env and argv but
this should not influence the real problem detection here.

Reproduction steps:
cc -o manymap manymap.c
ulimit -v unlimited
while true
do
	./manymap || break
done

> 
> If the stack really grows down to mmap_base then we can get silent mmap
> region overwrite by the stack values.
> 
> Let's include maximum stack randomization size into MIN_GAP which is
> used as the low bound for the gap in mmap.
> 
> Signed-off-by: Michal Hocko <mhocko@suse.cz>
> ---
>  arch/x86/mm/mmap.c |   21 +++++++++++++++++++--
>  1 files changed, 19 insertions(+), 2 deletions(-)
> 
> I wasn't sure about STACK_RND_MASK because it is defined also in 
> arch/x86/include/asm/elf.h and I couldn't find a common header file for 
> both of them. If you have any idea I would like to help with that.
> Or should we just let it for later cleanup?
> 
> I think that this is also stable material and I will repost it to 
> stable@kernel.org once you ack it.
> 
> Changes from v1:
> Fixed unsigned int overflow in MIN_GAP calculation.
> 
> 
> diff --git a/arch/x86/mm/mmap.c b/arch/x86/mm/mmap.c
> index 1658296..ac41955 100644
> --- a/arch/x86/mm/mmap.c
> +++ b/arch/x86/mm/mmap.c
> @@ -30,12 +30,29 @@
>  #include <linux/limits.h>
>  #include <linux/sched.h>
>  
> +/* 1GB for 64bit, 8MB for 32bit definition taken from arch/x86/include/asm/elf.h */
> +#ifndef STACK_RND_MASK
> +#define STACK_RND_MASK (test_thread_flag(TIF_IA32) ? 0x7ff : 0x3fffff)
> +#endif
> +
> +static unsigned int stack_maxrandom_size(void)
> +{
> +	unsigned int max = 0;
> +	if ((current->flags & PF_RANDOMIZE) &&
> +		!(current->personality & ADDR_NO_RANDOMIZE)) {
> +		max = ((-1U) & STACK_RND_MASK) << PAGE_SHIFT;
> +	}
> +
> +	return max;
> +}
> +
> +
>  /*
>   * Top of mmap area (just below the process stack).
>   *
> - * Leave an at least ~128 MB hole.
> + * Leave an at least ~128 MB hole with possible stack randomization.
>   */
> -#define MIN_GAP (128*1024*1024)
> +#define MIN_GAP (128*1024*1024UL + stack_maxrandom_size())
>  #define MAX_GAP (TASK_SIZE/6*5)
>  
>  /*
> -- 
> 1.6.3.3
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

-- 
Michal Hocko
L3 team 
SUSE LINUX s.r.o.
Lihovarska 1060/12
190 00 Praha 9    
Czech Republic

--9amGYk9869ThD9tj
Content-Type: text/x-csrc; charset=us-ascii
Content-Disposition: attachment; filename="manymap.c"


#include <stdlib.h>
#include <string.h>
#include <sys/mman.h>
#include <stdio.h>
#include <errno.h>
#include <sys/time.h>
#include <sys/resource.h>
#include <sys/stat.h>
#include <fcntl.h>

#define TRIES 2

void *
get_stack_addr();

void print_layout(pid_t pid)
{
	char maps_file[128];
	char buf[BUFSIZ];
	int fd;
	int bytes;
	snprintf(maps_file, sizeof(maps_file)-1, "/proc/%d/maps", pid);
	
	fd = open(maps_file, O_RDONLY);
	printf("%u MEMORY layout\n", pid);
	while((bytes = read(fd, buf, sizeof(buf)))>0)
	{
		buf[bytes]='\0';
		printf("%s", buf);
	}
	printf("END\n");
}

main()
{
    size_t len;
    int i;
    void *v1, *v, *vold;
    void *stacktop;
    void *mina, *maxa;
    struct rlimit stack_limit;
    pid_t pid=getpid();
    

    // len = 17179869184;
    // len = 34359738368;

   // did not infringe
    // len = 100000L  * 4096;

    len = 20000L  * 4096 * 1024;

    stacktop = get_stack_addr();
    getrlimit(RLIMIT_STACK, &stack_limit);

    //printf("stacktop is %lx\n",(long) stacktop);

    mina = (void*)0xFFFFFFFFFFFFFFFFL;
    maxa = 0;

    vold = 0;
    for (i=0; i<TRIES; i++) {
      	v = mmap (NULL, len, PROT_READ | PROT_WRITE,
            MAP_SHARED | MAP_ANONYMOUS | MAP_NORESERVE, -1, (off_t)0);
      	if (v == MAP_FAILED) {	printf("failed, errno=%d\n",errno); abort(); } 

	if (v < mina)       mina = v;
	if (v + len > maxa) maxa = v + len;

	vold = v;

  }

  unsigned long delta = (unsigned long)stacktop - (unsigned long)maxa;
  if (delta<stack_limit.rlim_cur)
  {
	printf("%u: mmaps zone %lx - %lx stack %lx delta %ld\n", pid,
				(unsigned long)mina, (unsigned long)maxa,
				(unsigned long)stacktop, 
				delta);
	printf("Dangerous layout!\n");
	print_layout(pid);
	abort();
  }
  return 0;
}

void *
get_stack_addr()
{
    char fname[BUFSIZ], fmt_str[BUFSIZ];
    FILE *fp;
    long val;
    int i;

    // find the stack starting addr in /proc/<PID>/stat

    sprintf(fname,"/proc/%d/stat",getpid());
    if (!(fp = fopen(fname, "r"))) {
        printf("Error opening %s\n",fname);
	abort();
    }

    // create format string.  The stack starting addr is param #28
    // we don't care about the first 27 parameters.

    strcpy(fmt_str,"%*d %*s %*c");
    for (i=4;i<28;i++) {
      strcat(fmt_str," %*d");
    }
    strcat(fmt_str," %lu");

    fscanf(fp,fmt_str,&val);
    fclose(fp);

    return (void *)val;
}


--9amGYk9869ThD9tj--
