Return-Path: <linux-kernel-owner+w=401wt.eu-S1760045AbZACPwg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760045AbZACPwg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Jan 2009 10:52:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759614AbZACPwP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Jan 2009 10:52:15 -0500
Received: from verein.lst.de ([213.95.11.210]:45676 "EHLO verein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759304AbZACPwP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Jan 2009 10:52:15 -0500
Date: Sat, 3 Jan 2009 16:52:09 +0100
From: Christoph Hellwig <hch@lst.de>
To: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org
Subject: devpts multiple instances feedback
Message-ID: <20090103155209.GA17988@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.3.28i
X-Spam-Score: 0 () 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I just took a look at the changes going into Linus current tree and
here's some feedback about the devpts multiple instances code:

 - the ptmx node is quite useful, I think it should always be around,
   even for normal devpts mounts.  That way distros can slowly migrate
   over to just using it by default and making the containers
   interaction easier.  It's also in many ways much nicer to have
   all the pty handling in one filesystems instead of sometimes
   using the character device.
 - the 000 mode is very weird, given how the /dev/ptmx operates
   it doesn't really make much sense to have it different than 0666
   unless you want to disable ptys.
 - why does pts_sb_from_inode have to check s_magic, I can't see
   it ever used on an inode not from the devpts filesystem
 - parsing the options twice is rather odd, I'd rather parse it into
   a once allocated structure then passed on through the private
   data void pointer into get_sb_nodev
 - creating the ptmx node should happen inside devfs_fill_super
 - once the ptmx mknod is gone I think new_pts_mount,
   is_new_instance_mount, init_pts_mount and maybe even get_init_pts_sb
   should be merged into devpts_get_sb to make the whole mounting
   scenario easier to follow instead of having to jump through half
   a dozen functions
 - I think CONFIG_DEVPTS_MULTIPLE_INSTANCES is not a good idea,
   it's not much code and could either be enabled unconditionally or
   based on the presence of a generic namespaces config option.
   (btw, this also applies to the other namespaces options, there's
   not much of a reason to have millions of options for them,
   one single option would be a lot easier for the user..)
