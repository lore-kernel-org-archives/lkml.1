Return-Path: <linux-kernel-owner+w=401wt.eu-S1760253AbZA3B1T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760253AbZA3B1T (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2009 20:27:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752335AbZA3B1J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Jan 2009 20:27:09 -0500
Received: from smtp-out.google.com ([216.239.33.17]:43832 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750701AbZA3B1H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2009 20:27:07 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:to:cc:subject:in-reply-to:message-id:references:
	mime-version:content-type;
	b=Ln3lHKVp9CoDJ2AjA46rqOMCUvW7I4oVcpxK74LJWaM+zJeHzQSDkGyDt77UZXybH
	soND+zigQslTzV6wmjxmQ==
Date: Thu, 29 Jan 2009 17:26:52 -0800 (PST)
From: Paul Turner <pjt@google.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
cc: Alexey Dobriyan <adobriyan@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, Paul Turner <pjt@google.com>,
       linux-kernel@vger.kernel.org
Subject: Re: Migration of kernel interfaces to seq_files breaks pread()
 consumers
In-Reply-To: <m1r62obev3.fsf@fess.ebiederm.org>
Message-ID: <Pine.LNX.4.64.0901291719520.26444@kitami.corp.google.com>
References: <Pine.LNX.4.64.0901162229420.12858@kitami.corp.google.com>
 <20090124181924.d633523c.akpm@linux-foundation.org> <20090125120818.GA4454@x200.localdomain>
 <m1r62obev3.fsf@fess.ebiederm.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 27 Jan 2009, Eric W. Biederman wrote:

> Alexey Dobriyan <adobriyan@gmail.com> writes:
> 
> > On Sat, Jan 24, 2009 at 06:19:24PM -0800, Andrew Morton wrote:
> >> On Fri, 16 Jan 2009 23:51:35 -0800 (PST) Paul Turner <pjt@google.com> wrote:
> >> 
> >> > 
> >> > (Specifically) Several interfaces under /proc have been migrated to use 
> >> > seq_files.  This was previously observed to be a problem with VMware's 
> >> > reading of /proc/uptime.  We're now running into the same problem on  
> >> > /proc/<pid>/stat; we have many consumers performing preads on this 
> >> > interface which break under new kernels.
> >> > 
> >> > Reverting these migrations presents other problems and doesn't scale with 
> >> > everyones' pet dependencies over an abi that's been
> >> > broken :(
> >> 
> >> We changed userspace-visible behaviour and broke real applications. 
> >> This is a serious matter.  So serious in fact that your report has
> >> languished without reply for a week.
> >> 
> >> Reverting those changes until we have a suitable reimplementation which
> >> doesn't bust userspace is 100% justifiable.
> >> 
> >> In which kernel versions is this regression present?
> >> 
> >> What would a revert look like?  Big and ugly or small and simple?  Do
> >> the original commits (which were they?) still revert OK?
> >
> > This is bug http://bugzilla.kernel.org/show_bug.cgi?id=11856
> > Some of us think what to do here.
> >
> > Original patch not revertable as is.
> 
> Interesting.  This seems like a bug in seq_file plain and simple.
> Userspace appears to be acting very reasonable in this case.
> 
> Why is there a notion that we have to differentiate between read
> and pread in seq_file to fix this.  That doesn't make much sense.
> 
> Anyway here is an untested but logically correct patch which should fix
> this issue, without nasty special casing of pread.
> 
> Eric
> 

Thanks Eric,

Moving the position into the seq_file structure is much cleaner.  Basic 
tests seem to work ok.

Few comments:
- seq_open needs its fmode opened up to take advantage of this [patch 
below]
- There's still the inherent problem of reads peturbing other reads (both 
read and pread).  Our applications should be ok with this, however it does 
deviate from the supposedly thread-safe pread semantics.

- Paul

---
 fs/seq_file.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/fs/seq_file.c b/fs/seq_file.c
index cd63d69..aa3621f 100644
--- a/fs/seq_file.c
+++ b/fs/seq_file.c
@@ -48,8 +48,6 @@ int seq_open(struct file *file, const struct seq_operations *op)
 	 */
 	file->f_version = 0;
 
-	/* SEQ files support lseek, but not pread/pwrite */
-	file->f_mode &= ~(FMODE_PREAD | FMODE_PWRITE);
 	return 0;
 }
 EXPORT_SYMBOL(seq_open);
-- 
1.5.4.5

