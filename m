Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756383Ab0BKPI2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Feb 2010 10:08:28 -0500
Received: from kandzendo.ru ([195.178.208.66]:51297 "EHLO tservice.net.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756307Ab0BKPIZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Feb 2010 10:08:25 -0500
Date: Thu, 11 Feb 2010 18:08:05 +0300
From: Evgeniy Polyakov <zbr@ioremap.net>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [WTF] ... is going on with current->fs->{root,mnt} accesses in pohmelfs
Message-ID: <20100211150805.GA18705@ioremap.net>
References: <20100210101246.GA3509@ioremap.net> <20100210102422.GM30031@ZenIV.linux.org.uk> <20100210104515.GA6207@ioremap.net> <20100210110011.GN30031@ZenIV.linux.org.uk> <20100210111115.GA8376@ioremap.net> <20100210115938.GO30031@ZenIV.linux.org.uk> <20100210133007.GA17744@ioremap.net> <20100210210248.GP30031@ZenIV.linux.org.uk> <20100210212933.GA19919@ioremap.net> <20100211030253.GQ30031@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100211030253.GQ30031@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 11, 2010 at 03:02:54AM +0000, Al Viro (viro@ZenIV.linux.org.uk) wrote:
> Um.  You do realize that d_move() happens with none of your locks held,
> right?  It's done in vfs_rename_{other,dir}() and the only thing held
> is s_vfs_rename_sem and i_mutex on parents.  How could your code in
> writeback be able to distinguish

No, it happens with my lock held. It is not a lock, but kind of
IO delegation, i.e. it is not dropped when rename or other protected
operation completed. Instead another client sends request to grab it and
server asks current holder to drop cache, perform writeback or whatever
else is needed.

It can be a problem though if d_move() is called outside of path
protected by the VFS dir operations like rename/created/unlink and so
on, i.e. on behalf of some entity in the kernel which decides to move
dentries on itself. In this case POHMELFS is not protected.

-- 
	Evgeniy Polyakov
