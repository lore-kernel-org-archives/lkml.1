Return-Path: <linux-kernel-owner+w=401wt.eu-S1756325AbYASW4I@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756325AbYASW4I (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jan 2008 17:56:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752199AbYASWz4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Jan 2008 17:55:56 -0500
Received: from py-out-1112.google.com ([64.233.166.181]:26312 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752143AbYASWzz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jan 2008 17:55:55 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=V8qSpiNRHXMv3yaBafm69kdFoHd/5/BLoFjwTPIvlup3BtrkATQOSlHK58+LrYxPzu6AvgdXqQHl/RS4lTfZv3Y42io+NoIZbeaDsSbi6x3mutK+UqVNTPuh1MAp5BVNYopmo60q6Uf9HOuywGIZPA0gd52kxgKBkcPW9StIA7s=
Message-ID: <524f69650801191455g5eab5edfw80f27136662a465c@mail.gmail.com>
Date: Sat, 19 Jan 2008 16:55:53 -0600
From: "Steve French" <smfrench@gmail.com>
To: "Andi Kleen" <andi@firstfloor.org>
Subject: Re: [linux-cifs-client] [PATCH] Remove information leak in Linux CIFS clientg
Cc: simo <idra@samba.org>, linux-kernel@vger.kernel.org,
       linux-cifs-client@lists.samba.org, samba-technical@lists.samba.org
In-Reply-To: <20080119223029.GA5786@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080119045552.GA11134@basil.nowhere.org>
	 <1200730722.28706.70.camel@localhost.localdomain>
	 <524f69650801191406j440e52afsb9b80efed4fa15da@mail.gmail.com>
	 <20080119223029.GA5786@one.firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Jan 19, 2008 4:30 PM, Andi Kleen <andi@firstfloor.org> wrote:
> On Sat, Jan 19, 2008 at 04:06:57PM -0600, Steve French wrote:
> > The access denied message in the dmesg log reveals no more information
> > than strace on stat of a local file does (which also returns access
>
> You can't strace a process you don't own. And you might not be able
> to access the directory below which the file is.

If you can't access the directory that the file is in then you get
access denied on stat of the file (local over ext3 or remote over
cifs) - it does not tell you anything about whether the file existed
or not.  If you do "stat
/mnt/dir-with-0700-perm/file-which-does-not-exist"  I get access
denied.  I don't think that it really tells you anything interesting
since the same error comes back whether or not the file existed.
Other unexpected errors (e.g. -EIO) should be logged because they
indicate possibly severe problems with the network, but also don't
tell you anything about whether the file exists.

> Logging the path would be only safe if you determine that the
> file and all its parent directories were world read (and accessable)able,
> but that would be probably difficult.

If the parent of the parent were not readable/accessable then you
would not have gotten this far (the stat of the parent directory
rather than the file would have returned the error).  If the parent
were readable then the access denied on stat is the same over cifs and
ext3 - and the logging of the error only occurs in cases like EIO in
which e.g. the network has crashed (but you can't tell from the error
whether the file exists or not).  I don't mind taking out the path
name from the logging of EIO in this case but it could make debugging
harder if we ever hit a strange bug.


-- 
Thanks,

Steve
