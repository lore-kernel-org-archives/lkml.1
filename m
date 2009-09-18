Return-Path: <linux-kernel-owner+w=401wt.eu-S1753886AbZIRMOK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753886AbZIRMOK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Sep 2009 08:14:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753093AbZIRMOJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Sep 2009 08:14:09 -0400
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:48296 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751509AbZIRMOI convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Sep 2009 08:14:08 -0400
Message-Id: <1253276050.9376.1335476075@webmail.messagingengine.com>
X-Sasl-Enc: +TwPG3XnCFwRLhnAIkUpDh97tF6sJ41ybDypdoJiqJo5 1253276050
From: jorg@ml1.net
To: "OGAWA Hirofumi" <hirofumi@mail.parknet.co.jp>,
       "Jorg Schummer" <ext-jorg.2.schummer@nokia.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: MessagingEngine.com Webmail Interface
In-Reply-To: <878wgcsd1p.fsf@devron.myhome.or.jp>
References: <1252420131.5782.2.camel@jorg-desktop><1252420448-7282-1-git-send-email-ext-jorg.2.schummer@nokia.com>
 <878wgcsd1p.fsf@devron.myhome.or.jp>
Subject: Re: [PATCH take 3][RFC] fat: Save FAT root directory timestamps to
 volume label
Date: Fri, 18 Sep 2009 15:14:10 +0300
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello and thanks for your comments!

On Fri, 18 Sep 2009 20:33 +0900, "OGAWA Hirofumi"
<hirofumi@mail.parknet.co.jp> wrote:
> Jorg Schummer <ext-jorg.2.schummer@nokia.com> writes:
> 
> > Standard FAT implementations cannot store any of the FAT root directory's
> > timestamps. This commit adds the mount option 'rootts', which allows saving
> > the FAT root directory timestamps as the timestamps of the FAT volume label
> > directory entry. At least Mac OS X is known to support the same mechanism
> > and interoperate with this commit.
> >
> > When mounting, the following values can be specified for the 'rootts' mount
> > option:
> >
...
> >
> >   "rootts=save"     tries to load and save the root directory's timestamps.
> >                     The mtime and atime are corrected based on root
> >                     directory entries' ctime. If the root directory was
> >                     accessed but no volume label entry exists, the label
> >                     "NO NAME" is created.
> 
> Um..., I'm still not sure though. rootts=save may not be needed for
> this, because it seems a bit complex, and it can do on userland...

It's true, that is quite of a hack after all. I just thought I'll try to
add the non-plus-ultra-feature on top of what Mac OS can do already.

But you're right, I'll get rid of the label creation. (And I think I
should get rid of the time stamp correction as well. If there is no
timestamp to be loaded, then 1970/1/1 should suffice. In case anyone
thinks that the timestamp 'correction' is anyhow useful, let me know...)

> 
> And some quick review of implement..
> 
> > +	if (inode->i_ino == MSDOS_ROOT_INO) {
> 
> In this path, we don't have inode->i_mutex, so to look directry up is
> wrong. I think adding label may move to userland.
> 
> I guess we should do all of preparation in fill_super().

True. This code is only needed for the time stamp creation, so it'll go
in any case.

> 
> > +			remove_inode_hash(inode);
> > +			fat_attach(inode, i_pos);
> > +			insert_inode_hash(inode);
> > +			brelse(bh);
> 
> Root inode should never change the position, so this shouldn't be
> needed.

Like above, this will be removed.

If 'preserve' (i.e. saving and loading the timestamp only IF a label is
present) is the default, I'll remove the 'rootts=preserve' option.
However, should there still be an option to switch this feature off
completely ('rootts=ignore')?

Thanks very much for your comments, the next version will come soon!

Jörg
