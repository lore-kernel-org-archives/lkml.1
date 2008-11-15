Return-Path: <linux-kernel-owner+w=401wt.eu-S1755589AbYKOBBT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755589AbYKOBBT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2008 20:01:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751869AbYKOBBJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Nov 2008 20:01:09 -0500
Received: from yx-out-2324.google.com ([74.125.44.29]:20704 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751610AbYKOBBI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2008 20:01:08 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Kw3KE7DL2116IG5gNF5On9BMckTRne3ZpL66rJfLgVOI3Equ3fUX/7JYmjuW8w9Dfb
         Oy7dSmZQvxeECE+Zjx0e3FZ3Y9YeJcQUs75Xq6d53iaagLgYm1CS3zm4JMsWa0efQv62
         noAZnRbSttbJZNTvKXf9OHGMhc3LV4cj556qQ=
Date: Fri, 14 Nov 2008 20:01:14 -0500
From: "J.R. Mauro" <jrm8005@gmail.com>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Greg KH <greg@kroah.com>, Stephen Rothwell <sfr@canb.auug.org.au>,
       linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       abbotti@mev.co.uk, fmhess@users.sourceforge.net, ds@schleef.org
Subject: Re: linux-next: Tree for November 14 (staging)
Message-ID: <20081115010114.GA29057@tuxbook-pro>
References: <20081114184021.ed198f4b.sfr@canb.auug.org.au> <20081114095247.6b195091.randy.dunlap@oracle.com> <20081114181124.GA23441@kroah.com> <491DC1CC.8020502@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <491DC1CC.8020502@oracle.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 14, 2008 at 10:22:04AM -0800, Randy Dunlap wrote:
> Greg KH wrote:
> > On Fri, Nov 14, 2008 at 09:52:47AM -0800, Randy Dunlap wrote:
> >> On Fri, 14 Nov 2008 18:40:21 +1100 Stephen Rothwell wrote:
> >>
> >>> Hi all,
> >>>
> >>> Changes since 20081113:
> >>>
> >>> New tree:
> >>> 	staging
> >>
> >> drivers/staging/benet/mpu.c:146: error: implicit declaration of function 'udelay'
> >>
> >> drivers/staging/comedi/proc.c:89: error: redefinition of 'comedi_proc_init'
> >> drivers/staging/comedi/comedidev.h:359: error: previous definition of 'comedi_proc_init' was here
> >> drivers/staging/comedi/proc.c:98: error: redefinition of 'comedi_proc_cleanup'
> >> drivers/staging/comedi/comedidev.h:362: error: previous definition of 'comedi_proc_cleanup' was here
> > 
> > Odd, I'm not getting these warnings here, can you give me a copy of your
> > .config?
> 
> 2 failing configs attached.
> 

The comedi driver does some wonky stuff if CONFIG_PROC_FS isn't set. It
conditionally defined these functions if it's set to a forward declaration, but
then if it's not set it makes them empty. However, the *real* definitions aren't
protected by the same kind of ifdefs. In case Greg can't reproduce this, here's 
a quick-n-dirty patch to do just that.

I think in reality there should be some way to exclude that proc.c file entirely
if CONFIG_PROC_FS is not set, but I'll leave that to the pros. (Whom I am adding
to the CC-list, BTW).

=

Don't include procfs functions if CONFIG_PROC_FS is not set

Signed-off by: J.R. Mauro <jrm8005@gmail.com>

---
 drivers/staging/comedi/proc.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/staging/comedi/proc.c b/drivers/staging/comedi/proc.c
index 7db12ac..5a2b72d 100644
--- a/drivers/staging/comedi/proc.c
+++ b/drivers/staging/comedi/proc.c
@@ -85,6 +85,7 @@ int comedi_read_procmem(char *buf, char **start, off_t offset, int len,
 	return l;
 }
 
+#ifdef CONFIG_PROC_FS
 void comedi_proc_init(void)
 {
 	struct proc_dir_entry *comedi_proc;
@@ -98,3 +99,4 @@ void comedi_proc_cleanup(void)
 {
 	remove_proc_entry("comedi", 0);
 }
+#endif
-- 
1.6.0.3

