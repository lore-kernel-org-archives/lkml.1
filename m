Return-Path: <linux-kernel-owner+w=401wt.eu-S1754652AbZKTRZQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754652AbZKTRZQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Nov 2009 12:25:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754233AbZKTRZQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Nov 2009 12:25:16 -0500
Received: from cantor.suse.de ([195.135.220.2]:44140 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753574AbZKTRZP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Nov 2009 12:25:15 -0500
Date: Fri, 20 Nov 2009 18:25:19 +0100
From: Jan Blunck <jblunck@suse.de>
To: Jamie Lokier <jamie@shareable.org>
Cc: linux-fsdevel@vger.kernel.org, Christoph Hellwig <hch@infradead.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Linux-Kernel Mailinglist <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, jkacur@redhat.com,
       Arnd Bergmann <arnd@arndb.de>,
       =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
       Willem Riede <osst@riede.org>,
       "James E.J. Bottomley" <James.Bottomley@suse.de>
Subject: Re: [PATCH 02/15] osst: Use noop_llseek() instead of default_llseek()
Message-ID: <20091120172519.GA21750@bolzano.suse.de>
References: <1258735245-25826-1-git-send-email-jblunck@suse.de> <1258735245-25826-3-git-send-email-jblunck@suse.de> <20091120170906.GG20634@shareable.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091120170906.GG20634@shareable.org>
Organization: SUSE LINUX Products GmbH, GF Markus Rex, HRB 16746 (AG Nuernberg)
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 20, Jamie Lokier wrote:

> Jan Blunck wrote:
> > __os_scsi_tape_open() suggests that llseek() doesn't work:
> > "We really want to do nonseekable_open(inode, filp); here, but some
> >  versions of tar incorrectly call lseek on tapes and bail out if that
> >  fails.  So we disallow pread() and pwrite(), but permit lseeks."
> > 
> > Instead of using the fallback default_llseek() the driver should use
> > noop_llseek() which leaves the file->f_pos untouched but succeeds.
> 
> st.c has the same comment, but I didn't see a patch for st.c in the series.
> 

Right, that would make sense.

I wonder if anyone has this weird tar and could test if it actually works.

-- 
st: Use noop_llseek() instead of default_llseek()

st_open() suggests that llseek() doesn't work:
"We really want to do nonseekable_open(inode, filp); here, but some
versions of tar incorrectly call lseek on tapes and bail out if that
fails.  So we disallow pread() and pwrite(), but permit lseeks."

Instead of using the fallback default_llseek() the driver should use
noop_llseek() which leaves the file->f_pos untouched but succeeds.

Signed-off-by: Jan Blunck <jblunck@suse.de>
---
diff --git a/drivers/scsi/st.c b/drivers/scsi/st.c
index 12d58a7..9f03668 100644
--- a/drivers/scsi/st.c
+++ b/drivers/scsi/st.c
@@ -3958,6 +3958,7 @@ static const struct file_operations st_fops =
 	.open =		st_open,
 	.flush =	st_flush,
 	.release =	st_release,
+	.llseek =	noop_llseek,
 };
 
 static int st_probe(struct device *dev)
