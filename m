Return-Path: <linux-kernel-owner+w=401wt.eu-S1759988AbYDOWsP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759988AbYDOWsP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2008 18:48:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753106AbYDOWr4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Apr 2008 18:47:56 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:51077 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750919AbYDOWry (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2008 18:47:54 -0400
Date: Tue, 15 Apr 2008 17:47:50 -0500
From: Michael Halcrow <mhalcrow@us.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-fsdevel@vger.kernel.org, containers@lists.osdl.org,
       linux-kernel@vger.kernel.org, ecryptfs-devel@lists.sourceforge.net
Subject: Re: [Ecryptfs-devel] [PATCH 1/2] eCryptfs: Introduce device handle for userspace daemon communications
Message-ID: <20080415224750.GN4627@localhost.austin.ibm.com>
Reply-To: Michael Halcrow <mhalcrow@us.ibm.com>
References: <20080415202313.GM4627@localhost.austin.ibm.com> <20080415140453.a45a15b4.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080415140453.a45a15b4.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 15, 2008 at 02:04:53PM -0700, Andrew Morton wrote:
> On Tue, 15 Apr 2008 15:23:13 -0500
> Michael Halcrow <mhalcrow@us.ibm.com> wrote:
>
> > Functions to facilitate reading and writing to the eCryptfs
> > miscellaneous device handle. This will replace the netlink interface
> > as the preferred mechanism for communicating with the userspace
> > eCryptfs daemon.
> > 
> > Each user has his own daemon, which registers itself by opening the
> > eCryptfs device handle. Only one daemon per euid may be registered at
> > any given time. The eCryptfs module sends a message to a daemon by
> > adding its message to the daemon's outgoing message queue. The daemon
> > reads the device handle to get the oldest message off the queue.
> > 
> > Incoming messages from the userspace daemon are immediately
> > handled. If the message is a response, then the corresponding process
> > that is blocked waiting for the response is awakened.
> 
> This is a drastic change, but the changelog doesn't tell us why it
> is being made!

This resurrects the question from 2006:

On Thu, Aug 24, 2006 at 08:54:19PM -0700, Andrew Morton wrote:
> - _why_ does it use netlink?

I responded:

> Netlink provides the transport mechanism that would minimize the
> complexity of the implementation, given that we can have multiple
> daemons (one per user).

A regular device file was my real preference from the get-go, but I
went with netlink at the time because I thought it would be less
complex for managing send queues (i.e., just do a unicast and move
on). It turns out that we do not really get that much complexity
reduction with netlink, and netlink is more heavyweight than a device
handle.

In addition, the netlink interface to eCryptfs has been broken since
2.6.24. I am assuming this is a bug in how eCryptfs uses netlink,
since the other in-kernel users of netlink do not seem to be having
any problems. I have had one report of a user successfully using
eCryptfs with netlink on 2.6.24, but for my own systems, when starting
the userspace daemon, the initial helo message sent to the eCryptfs
kernel module results in an oops right off the bat. I spent some time
looking at it, but I have not yet found the cause. The netlink
interface breaking gave me the motivation to just finish my patch to
migrate to a regular device handle. If I cannot find out soon why the
netlink interface in eCryptfs broke, I am likely to just send a patch
to disable it in 2.6.24 and 2.6.25. I would like the device handle to
be the preferred means of communicating with the userspace daemon from
2.6.26 on forward.

Mike
