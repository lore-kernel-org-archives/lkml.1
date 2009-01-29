Return-Path: <linux-kernel-owner+w=401wt.eu-S1758368AbZA2VPo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758368AbZA2VPo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2009 16:15:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754634AbZA2VPW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Jan 2009 16:15:22 -0500
Received: from charlotte.tuxdriver.com ([70.61.120.58]:60050 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754514AbZA2VPV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2009 16:15:21 -0500
Date: Thu, 29 Jan 2009 16:15:05 -0500
From: Neil Horman <nhorman@tuxdriver.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: horms@verge.net.au, randy.dunlap@oracle.com, linux-kernel@vger.kernel.org,
       miaox@cn.fujitsu.com, vgoyal@redhat.com
Subject: Re: mmotm 2009-01-28-02-17 uploaded (i386 build errors: cpusets &
	kexec)
Message-ID: <20090129211505.GA10122@hmsreliant.think-freely.org>
References: <200901281019.n0SAJ9C6013727@imap1.linux-foundation.org> <49808E3F.1090805@oracle.com> <20090128163040.88b05b3d.akpm@linux-foundation.org> <20090129022846.GA1319@verge.net.au> <20090129120935.GB9221@hmsreliant.think-freely.org> <20090129100157.965bd396.akpm@linux-foundation.org> <20090129192734.GA10037@hmsreliant.think-freely.org> <20090129114859.ed963b2f.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090129114859.ed963b2f.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-Spam-Score: -1.4 (-)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 29, 2009 at 11:48:59AM -0800, Andrew Morton wrote:
> On Thu, 29 Jan 2009 14:27:34 -0500
> Neil Horman <nhorman@tuxdriver.com> wrote:
> 
> > On Thu, Jan 29, 2009 at 10:01:57AM -0800, Andrew Morton wrote:
> > > On Thu, 29 Jan 2009 07:09:35 -0500 Neil Horman <nhorman@tuxdriver.com> wrote:
> > > 
> > > > > > So does that.
> > > > > > 
> > > > > > --- a/kernel/printk.c~kexec-add-dmesg-log-symbols-to-proc-vmcoreinfo-lists-fix-fix
> > > > > > +++ a/kernel/printk.c
> > > > > > @@ -137,11 +137,13 @@ static char *log_buf = __log_buf;
> > > > > >  static int log_buf_len = __LOG_BUF_LEN;
> > > > > >  static unsigned logged_chars; /* Number of chars produced since last read+clear operation */
> > > > > >  
> > > > > > +#ifdef CONFIG_KEXEC
> > > > > >  void log_buf_kexec_setup(void)
> > > > > >  {
> > > > > >  	VMCOREINFO_SYMBOL(log_buf);
> > > > > >  	VMCOREINFO_SYMBOL(log_end);
> > > > > >  }
> > > > > > +#endif
> > > > > >  
> > > > > >  static int __init log_buf_len_setup(char *str)
> > > > > >  {
> > > > > > _
> > > > > 
> > > > > Weird, I thought I checked that just now. In any case this email
> > > > > was already in my inbox. In any case, I can now produce the problem,
> > > > > and this patch resolves it.
> > > > > 
> > > > 
> > > > Sorry, i didn't think to check on conditions when CONFIG_KEXEC wasn't set.  I
> > > > assumed we had a stub for all the VMCOREINFO defines.  Why don't we fix it in
> > > > that manner?  I mean we have serveral arch specific additions to vmcoreinfo, all
> > > > of which apparently must be ifdefd for this to work.  Why not just fix it in
> > > > conditional definition?
> > > 
> > > I didn't do that because then we'd have an empty function log_buf_kexec_setup()
> > > floating about in every vmlinux.
> > > 
> > > Hardly a big issue, but a bit regrettable.
> > > 
> > Won't the compiler just eliminate that symbol during final link, given that its
> > not an exported symbol?
> 
> I don't think it's that smart.
> 
> akpm:/home/akpm> cat t.c
> 
> void foo(void)
> {
> }
> 	
> main()
> {
> }
> akpm:/home/akpm> gcc -O2 t.c
> akpm:/home/akpm> nm a.out|grep foo
> 08048300 T foo
> 
> With -ffunction-sections or other fancy options, maybe.  And it'll be
> version-dependent.
> 
huh, how about that.  I always thought we stripped out empty functions.  Perhaps
that a later stage in most of the build processes I've used (a strip or
something later on perhaps).  Anywho, I stand corrected.  In light of this, its
probably best that we keep what we have, and just ifdef out the callers.

Thanks Andrew!
Neil

> 
