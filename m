Return-Path: <linux-kernel-owner+w=401wt.eu-S965580AbXCGQ4J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965580AbXCGQ4J (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 11:56:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965587AbXCGQ4J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 11:56:09 -0500
Received: from smtp.osdl.org ([65.172.181.24]:43366 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965580AbXCGQ4G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 11:56:06 -0500
Date: Wed, 7 Mar 2007 08:52:18 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
cc: Hugh Dickins <hugh@veritas.com>, Oliver Neukum <oliver@neukum.name>,
       Maneesh Soni <maneesh@in.ibm.com>, Greg Kroah-Hartman <gregkh@suse.de>,
       Adrian Bunk <bunk@stusta.de>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.21-rc suspend regression: sysfs deadlock
In-Reply-To: <d120d5000703070756v4fe11a54u9009d3efd93faa9d@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0703070845500.5963@woody.linux-foundation.org>
References: <Pine.LNX.4.64.0703061914030.18144@blonde.wat.veritas.com> 
 <Pine.LNX.4.64.0703061735350.5963@woody.linux-foundation.org>
 <d120d5000703070756v4fe11a54u9009d3efd93faa9d@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 7 Mar 2007, Dmitry Torokhov wrote:
> 
> ... with the exception that it will again make data associated with
> sysfs attributes accessible past the point of returning from
> sysfs_remove_file. And that was the point so drivers would not have to
> care about handling access to extra data (such as static strings) past
> the driver unload.

Drivers are unloaded by stopping the whole machine (exactly because module 
unload is otherwise so hard to handle), so that never happens unless you 
actively block. In other words, if you do something as simple as

	if (inode->i_private_data)
		sysfs_flush_buffer(buffer);

then there is no race with unloading (unless the driver itself does 
something stupid, of course - but the whole point of having a kernel 
buffer is so that it does *not* have to make user accesses etc).

But the one thing you should *not* do is to depend on a sleeping lock, 
because that breaks the whole model!

			Linus
