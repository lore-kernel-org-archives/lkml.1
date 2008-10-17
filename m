Return-Path: <linux-kernel-owner+w=401wt.eu-S1755416AbYJQO6j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755416AbYJQO6j (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2008 10:58:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754212AbYJQO6a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Oct 2008 10:58:30 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:44412 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754045AbYJQO6a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2008 10:58:30 -0400
Date: Fri, 17 Oct 2008 10:58:28 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Jeremy Fitzhardinge <jeremy@goop.org>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-usb <linux-usb@vger.kernel.org>
Subject: Re: Oops in UHCI when encountering "host controller process error"
In-Reply-To: <48F7E3B8.2090106@goop.org>
Message-ID: <Pine.LNX.4.44L0.0810171046530.2178-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 16 Oct 2008, Jeremy Fitzhardinge wrote:

> Looks like this is the relevent detail: "uhci->skelqh[1]->node.next is 
> NULL" for all the queues.  Haven't looked into it yet.

> ------------[ cut here ]------------
> WARNING: at /home/jeremy/hg/xen/paravirt/linux/drivers/usb/host/uhci-q.c:1744 uhci_scan_schedule+0xb7/0x9a3()
> uhci->skelqh[1]->node.next is NULL

Odd.  Is skelqh[1] the only entry whose node.next is NULL?  Not 
skelqh[2] or others?

The node is initialized during uhci_start() in uhci-hcd.c -- there's a
loop which initializes all the uhci->skelqh[i] entries by calling
uhci_alloc_qh().  You should check inside that loop to see whether
uhci->skelqh[i]->node.next is NULL to begin with.  If it is then
something about the DMA-coherent memory is funny; if not then the
linked list pointer gets corrupted somewhere.

Alan Stern

