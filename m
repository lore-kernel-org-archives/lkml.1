Return-Path: <linux-kernel-owner+w=401wt.eu-S1753704AbZI0Jyu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753704AbZI0Jyu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Sep 2009 05:54:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753536AbZI0Jyt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Sep 2009 05:54:49 -0400
Received: from gw1.cosmosbay.com ([212.99.114.194]:35917 "EHLO
	gw1.cosmosbay.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752621AbZI0Jys (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Sep 2009 05:54:48 -0400
Message-ID: <4ABF360E.7080301@gmail.com>
Date: Sun, 27 Sep 2009 11:53:18 +0200
From: Eric Dumazet <eric.dumazet@gmail.com>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: Yakov Lerner <iler.ml@gmail.com>
CC: linux-kernel@vger.kernel.org, netdev@vger.kernel.org, davem@davemloft.net,
       kuznet@ms2.inr.ac.ru, pekkas@netcore.fi, jmorris@namei.org,
       yoshfuji@linux-ipv6.org, kaber@trash.net, torvalds@linux-foundation.org
Subject: Re: [PATCH] /proc/net/tcp, overhead removed
References: <1254000675-8327-1-git-send-email-iler.ml@gmail.com>
In-Reply-To: <1254000675-8327-1-git-send-email-iler.ml@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.6 (gw1.cosmosbay.com [0.0.0.0]); Sun, 27 Sep 2009 11:53:23 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yakov Lerner a écrit :
> /proc/net/tcp does 20,000 sockets in 60-80 milliseconds, with this patch.
> 
> The overhead was in tcp_seq_start(). See analysis (3) below.
> The patch is against Linus git tree (1). The patch is small.
> 
> ------------  -----------   ------------------------------------
> Before patch  After patch   20,000 sockets (10,000 tw + 10,000 estab)(2)
> ------------  -----------   ------------------------------------
> 6 sec          0.06 sec     dd bs=1k if=/proc/net/tcp >/dev/null 
> 1.5 sec        0.06 sec     dd bs=4k if=/proc/net/tcp >/dev/null
> 
> 1.9 sec        0.16 sec     netstat -4ant >/dev/null
> ------------  -----------   ------------------------------------
> 
> This is ~ x25 improvement.
> The new time is not dependent on read blockize.
> Speed of netstat, naturally, improves, too; both -4 and -6.
> /proc/net/tcp6 does 20,000 sockets in 100 millisec.
> 
> (1) against git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6.git
> 
> (2) Used 'manysock' utility to stress system with large number of sockets:
>   "manysock 10000 10000"    - 10,000 tw + 10,000 estab ip4 sockets.
>   "manysock -6 10000 10000" - 10,000 tw + 10,000 estab ip6 sockets.
> Found at http://ilerner.3b1.org/manysock/manysock.c
> 
> (3) Algorithmic analysis. 
>     Old algorithm.
> 
> During 'cat </proc/net/tcp', tcp_seq_start() is called O(numsockets) times (4).
> On average, every call to tcp_seq_start() scans half the whole hashtable. Ouch.
> This is O(numsockets * hashsize). 95-99% of 'cat </proc/net/tcp' is spent in
> tcp_seq_start()->tcp_get_idx. This overhead is eliminated by new algorithm,
> which is O(numsockets + hashsize).
> 
>     New algorithm.
> 
> New algorithms is O(numsockets + hashsize). We jump to the right
> hash bucket in tcp_seq_start(), without scanning half the hash.
> To jump right to the hash bucket corresponding to *pos in tcp_seq_start(),
> we reuse three pieces of state (st->num, st->bucket, st->sbucket)
> as follows:
>  - we check that requested pos >= last seen pos (st->num), the typical case. 
>  - if so, we jump to bucket st->bucket
>  - to arrive to the right item after beginning of st->bucket, we
> keep in st->sbucket the position corresponding to the beginning of
> bucket.
> 
> (4) Explanation of O( numsockets * hashsize) of old algorithm.
> 
> tcp_seq_start() is called once for every ~7 lines of netstat output 
> if readsize is 1kb, or once for every ~28 lines if readsize >= 4kb.
> Since record length of /proc/net/tcp records is 150 bytes, formula for
> number of calls to tcp_seq_start() is
>             (numsockets * 150 / min(4096,readsize)).
> Netstat uses 4kb readsize (newer versions), or 1kb (older versions).
> Note that speed of old algorithm does not improve above 4kb blocksize.
> 
> Speed of the new algorithm does not depend on blocksize.
> 
> Speed of the new algorithm does not perceptibly depend on hashsize (which
> depends on ramsize). Speed of old algorithm drops with bigger hashsize.
> 
> (5) Reporting order.
> 
> Reporting order is exactly same as before if hash does not change underfoot.
> When hash elements come and go during report, reporting order will be
> same as that of tcpdiag.
> 
> Signed-off-by: Yakov Lerner <iler.ml@gmail.com>
> ---
>  net/ipv4/tcp_ipv4.c |   26 ++++++++++++++++++++++++--
>  1 files changed, 24 insertions(+), 2 deletions(-)
> 
> diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
> index 7cda24b..7d9421a 100644
> --- a/net/ipv4/tcp_ipv4.c
> +++ b/net/ipv4/tcp_ipv4.c
> @@ -1994,13 +1994,14 @@ static inline int empty_bucket(struct tcp_iter_state *st)
>  		hlist_nulls_empty(&tcp_hashinfo.ehash[st->bucket].twchain);
>  }
>  
> -static void *established_get_first(struct seq_file *seq)
> +static void *established_get_first_after(struct seq_file *seq, int bucket)
>  {
>  	struct tcp_iter_state *st = seq->private;
>  	struct net *net = seq_file_net(seq);
>  	void *rc = NULL;
>  
> -	for (st->bucket = 0; st->bucket < tcp_hashinfo.ehash_size; ++st->bucket) {
> +	for (st->bucket = bucket; st->bucket < tcp_hashinfo.ehash_size;
> +	     ++st->bucket) {
>  		struct sock *sk;
>  		struct hlist_nulls_node *node;
>  		struct inet_timewait_sock *tw;
> @@ -2036,6 +2037,11 @@ out:
>  	return rc;
>  }
>  
> +static void *established_get_first(struct seq_file *seq)
> +{
> +	return established_get_first_after(seq, 0);
> +}
> +
>  static void *established_get_next(struct seq_file *seq, void *cur)
>  {
>  	struct sock *sk = cur;
> @@ -2045,6 +2051,7 @@ static void *established_get_next(struct seq_file *seq, void *cur)
>  	struct net *net = seq_file_net(seq);
>  
>  	++st->num;
> +	st->sbucket = st->num;

Hello Yakov

Intention of your patch is very good, but not currently working.

It seems you believe there is at most one entry per hash slot or something like that

Please reboot your test machine with "thash_entries=4096" so that tcp hash
size is 4096, and try to fill 20000 tcp sockets with a test program.

then :

# ss | wc -l
20001
(ok)

# cat /proc/net/tcp | wc -l
22160
(not quite correct ...)

# netstat -tn | wc -l
<never ends>


# dd if=/proc/net/tcp ibs=1024 | wc -l
<never ends>


Please send your next patch on netdev@vger.kernel.org , DaveM only , were netdev people
are reviewing netdev patches, there is no need include other people for first submissions.

Thank you


#include <sys/types.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <string.h>
int fdlisten;
main()
{
        int i;
        struct sockaddr_in sockaddr;

        fdlisten = socket(AF_INET, SOCK_STREAM, 0);
        memset(&sockaddr, 0, sizeof(sockaddr));
        sockaddr.sin_family = AF_INET;
        sockaddr.sin_port = htons(2222);
        if (bind(fdlisten, (struct sockaddr *)&sockaddr, sizeof(sockaddr))== -1) {
                perror("bind");
                return 1;
        }
        if (listen(fdlisten, 10)== -1) {
                perror("listen");
                return 1;
        }
        if (fork() == 0) {
                while (1) {
                        socklen_t len = sizeof(sockaddr);
                        int newfd = accept(fdlisten, (struct sockaddr *)&sockaddr, &len);
                }
        }
        for (i = 0 ; i < 10000; i++) {
                int fd = socket(AF_INET, SOCK_STREAM, 0);
                if (fd == -1) {
                        perror("socket");
                        break;
                        }
                connect(fd, (struct sockaddr *)&sockaddr, sizeof(sockaddr));
        }
        pause();
}
