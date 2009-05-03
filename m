Return-Path: <linux-kernel-owner+w=401wt.eu-S1756804AbZECTWV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756804AbZECTWV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 May 2009 15:22:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752279AbZECTWG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 May 2009 15:22:06 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:58926 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754168AbZECTWF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 May 2009 15:22:05 -0400
Date: Sun, 3 May 2009 20:22:01 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Davide Libenzi <davidel@xmailserver.org>
Cc: Gregory Haskins <ghaskins@novell.com>, kvm@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       avi@redhat.com, hirofuchi@users.sourceforge.net, ericvh@gmail.com
Subject: file descriptor abuses
Message-ID: <20090503192201.GA8633@ZenIV.linux.org.uk>
References: <20090427182540.6646.96740.stgit@dev.haskins.net> <20090427183334.6646.90800.stgit@dev.haskins.net> <20090503064432.GS8633@ZenIV.linux.org.uk> <alpine.DEB.1.10.0905031103290.7899@makko.or.mcafeemobile.com> <20090503190136.GY8633@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090503190136.GY8633@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 03, 2009 at 08:01:36PM +0100, Al Viro wrote:

> General rules:
> 	* descriptor you've generated is fit only for return to userland;
> 	* descriptor you've got from userland is fit only for *single*
> fget() or equivalent, unless you are one of the core syscalls manipulating
> the descriptor table itself (dup2, etc.)
> 	* once file is installed in descriptor table, you'd better be past
> the last failure exit; sys_close() on cleanup path is not acceptable.
> That's what reserving descriptors is for.
> 
> IOW, the sane solution would be to export something that returns your
> struct file *.  And stop playing with fd completely.

Speaking of which, quick look through fget() callers shows this turd:

static int p9_socket_open(struct p9_client *client, struct socket *csocket)
{
	int fd, ret;

	fd = sock_map_fd(csocket, 0);
	.....

	ret = p9_fd_open(client, fd, fd);
	if (ret < 0) {
		P9_EPRINTK(KERN_ERR, "p9_socket_open: failed to open fd\n");
		sockfd_put(csocket);
		return ret;
	}
	.....
	return 0;
}

where p9_fd_open() calls fget() on its 2nd and 3rd arguments.  Which does
worse than just a leak, AFAICT - on failure exit it leaves a dangling
pointer from descriptor table.

On the almost unrelated note, we have (in drivers/sneak_in^Wstaging/usbip)
sockfd_to_socket(), with all callers leaking struct file, AFAICS.
