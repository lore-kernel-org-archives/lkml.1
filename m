Return-Path: <linux-kernel-owner+w=401wt.eu-S1753656AbZBHLJN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753656AbZBHLJN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Feb 2009 06:09:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753275AbZBHLI6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Feb 2009 06:08:58 -0500
Received: from kirsty.vergenet.net ([202.4.237.240]:54102 "EHLO
	kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753240AbZBHLI5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Feb 2009 06:08:57 -0500
Date: Sun, 8 Feb 2009 17:52:37 +0900
From: Simon Horman <horms@verge.net.au>
To: Neil Horman <nhorman@tuxdriver.com>
Cc: "Ken'ichi Ohmichi" <oomichi@mxs.nes.nec.co.jp>,
       Eric Biederman <ebiederm@xmision.com>, kexec@lists.infradead.org,
       linux-kernel@vger.kernel.org, hbabu@us.ibm.com,
       Andrew Morton <akpm@linux-foundation.org>,
       Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [PATCH]: add dmesg log symbols to /proc/vmcoreinfo lists
Message-ID: <20090208085235.GA2804@verge.net.au>
References: <20090119212127.GA13157@hmsreliant.think-freely.org> <20090120141551.GA5125@redhat.com> <20090120150958.GB18207@hmsreliant.think-freely.org> <20090120152255.GB5125@redhat.com> <20090127001211.f847ea5a.akpm@linux-foundation.org> <20090128041109.GA4943@verge.net.au> <m1ljsnz1up.fsf@fess.ebiederm.org> <20090204120549.GA2182@hmsreliant.think-freely.org> <498A317A.8030707@mxs.nes.nec.co.jp> <20090205115254.GA15621@hmsreliant.think-freely.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090205115254.GA15621@hmsreliant.think-freely.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 05, 2009 at 06:52:54AM -0500, Neil Horman wrote:
> On Thu, Feb 05, 2009 at 09:23:22AM +0900, Ken'ichi Ohmichi wrote:
> > 
> > Hi Neil,
> > 
> > Thank you for a kernel patch and a makedumpfile patch.
> > 
> > Neil Horman wrote:
> > >> That aside we aren't currently exporting log_buf_len, so I don't
> > >> think this code works actually works.
> > >>
> > >> Neil can you add a comment in kernel/printk.c of the algorithm
> > >> necessary for external tools to decode the ring buffer?
> > >>
> > >> We need the comment because people working on kernel/printk.c
> > >> need to know what is happening and without having to review lots
> > >> of user space code, and we need the comment to verify that we
> > >> are exporting the right things.
> > >>
> > > 
> > > Ok, as per Erics comment, I've written this.  It applies on top of whats already
> > > in your tree Andrew.  It adds some comments on the function in question so that
> > > anyone working on printk.c will know why we're exporting their symbols.  It also
> > > modifies slightly the symbols we are exporting so that we can handle dmesg
> > > buffers that are longer than the standard PAGE_SIZE configuration, and lets us
> > > detect and handle buffer wraps.
> > > 
> > > Thanks!
> > > 
> > > printk.c |   12 +++++++++++-
> > > 1 file changed, 11 insertions(+), 1 deletion(-)
> > > 
> > > Signed-off-by: Neil Horman <nhorman@tuxdriver.com>
> > > 
> > > diff --git a/kernel/printk.c b/kernel/printk.c
> > > index dd5cc7b..6a1163b 100644
> > > --- a/kernel/printk.c
> > > +++ b/kernel/printk.c
> > > @@ -138,10 +138,20 @@ static int log_buf_len = __LOG_BUF_LEN;
> > >  static unsigned logged_chars; /* Number of chars produced since last read+clear operation */
> > >  
> > >  #ifdef CONFIG_KEXEC
> > > +/*
> > > + * This appends the listed symbols to /proc/vmcoreinfo
> > > + * /proc/vmcoreinfo is used by various utiilties, like
> > > + * crash and makedumpfile to obtain access to symbols that
> > > + * are otherwise very difficult to locate.  These symbols 
> > > + * are specifically used so that utilities 
> > > + * can access and extract the dmesg log from a vmcore file
> > > + * after a crash
> > > + */
> > >  void log_buf_kexec_setup(void)
> > >  {
> > >  	VMCOREINFO_SYMBOL(log_buf);
> > > -	VMCOREINFO_SYMBOL(log_end);
> > > +	VMCOREINFO_SYMBOL(log_buf_len);
> > > +	VMCOREINFO_SYMBOL(logged_chars)
> > >  }
> > >  #endif
> > 
> > Please do not remove VMCOREINFO_SYMBOL(log_end), because makedumpfile
> > needs it for knowing the latest log offset in ring buffer of dmesg.
> > I updated a makedumpfile patch for handling ring buffer, and it is
> > possible to download the latest patch from the following site:
> > 
> > https://sourceforge.net/tracker2/download.php?group_id=178938&atid=887142&file_id=312113&aid=2521075
> > 
> Understood, new patch attached.
> 
> Add some comments and extra symbols on top of whats there for kernel/printk.c to
> satisfy Erics requests, and support Ken'ichi's enhanced version of the
> makedumpfile patch
> 
> Neil
> 
> Signed-off-by: Neil Horman <nhorman@tuxdriver.com>
> 
> 
> 
>  printk.c |   11 +++++++++++
>  1 file changed, 11 insertions(+)
> 
> 
> diff --git a/kernel/printk.c b/kernel/printk.c
> index dd5cc7b..6c25eba 100644
> --- a/kernel/printk.c
> +++ b/kernel/printk.c
> @@ -138,10 +138,21 @@ static int log_buf_len = __LOG_BUF_LEN;
>  static unsigned logged_chars; /* Number of chars produced since last read+clear operation */
>  
>  #ifdef CONFIG_KEXEC
> +/*
> + * This appends the listed symbols to /proc/vmcoreinfo
> + * /proc/vmcoreinfo is used by various utiilties, like

Utilities appears to have a typo.

> + * crash and makedumpfile to obtain access to symbols that
> + * are otherwise very difficult to locate.  These symbols 
> + * are specifically used so that utilities 
> + * can access and extract the dmesg log from a vmcore file
> + * after a crash
> + */
>  void log_buf_kexec_setup(void)
>  {
>  	VMCOREINFO_SYMBOL(log_buf);
>  	VMCOREINFO_SYMBOL(log_end);
> +	VMCOREINFO_SYMBOL(log_buf_len);
> +	VMCOREINFO_SYMBOL(logged_chars)
>  }
>  #endif

-- 
Simon Horman
  VA Linux Systems Japan K.K., Sydney, Australia Satellite Office
  H: www.vergenet.net/~horms/             W: www.valinux.co.jp/en

