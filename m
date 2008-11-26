Return-Path: <linux-kernel-owner+w=401wt.eu-S1753512AbYKZA0b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753512AbYKZA0b (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2008 19:26:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752276AbYKZA0W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Nov 2008 19:26:22 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35083 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751193AbYKZA0V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2008 19:26:21 -0500
Date: Tue, 25 Nov 2008 16:24:34 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Evgeniy Polyakov <zbr@ioremap.net>
Cc: john@johnmccutchan.com, arnd@arndb.de, mtk.manpages@gmail.com, hch@lst.de,
       rlove@rlove.org, linux-api@vger.kernel.org,
       linux-kernel@vger.kernel.org, pavel@suse.cz, davidn@davidnewall.com,
       Eric Paris <eparis@redhat.com>
Subject: Re: [take2] Inotify: nested attributes support.
Message-Id: <20081125162434.4feacbbf.akpm@linux-foundation.org>
In-Reply-To: <20081125194234.GA24449@ioremap.net>
References: <20081125194234.GA24449@ioremap.net>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 25 Nov 2008 22:42:35 +0300
Evgeniy Polyakov <zbr@ioremap.net> wrote:

> Hi.
> 
> Attached patch (also attached test application) implementes
> scalable nested attributes which are transferred on behalf the inotify
> mechanism. It uses inotify_init1() to show that new event format should
> be returned when reading from inotify file descriptor.
> 
> Attributes are attached to given inotify instance via TIOCSETD ioctl,
> where ID of the attribute is transferred. If entry with given ID exists,
> it is removed and -EEXIST is returned.
> 
> There is a set of callbacks indexed by ID (currently 4 attributes are
> supported: pid, tid, io details (start/size of the written block) and
> name), which are attached to given inotify device.
> When new event is created, each callback is executed and may queue some
> data into event structure, based on its internal details. When event is
> read from the userspace, first its header is transferred (old
> inotify_event structure) and then all attributes data in the order of
> its registration via above ioctl. Nested attributes have following
> structure: 
> 
> struct inotify_attribute
> {
> 	unsigned int		id;
> 	unsigned int		size;
> 	unsigned char		data[0];
> };
> 
> where size is nuber of attached bytes for given attribute.
> inotify_event.len contains number of bytes used to store all attached
> attributes and data.
> 
> Attribute callback can check if mask contains its bits and do some steps
> based on that information, for example io details attribute does not add
> own data (and header) if event mask does not contain IN_MODIFY bit.
> 
> It is possible to infinitely extend number of attributes processed, so
> we will be no longer limited by inotify API and ABI.
> 
> Test application usage:
> $ gcc ./iotest.c -W -Wall -I/path/to/kernel/include/ -o iotest
> $ ./iotest -f /tmp/ -t -n -p -i
> 2008-11-25 22:29:47.8477 pid: 1850, tid: 1850, name: /tmp/, wd: 1, mask: 303, attributes: pid: 1, tid: 1, io: 1, name: 1.
> event: 2, wd: 1, cookie: 0, len: 61.
> 	tid: 1672.
> 	pid: 1672.
> 	io details: start: 0, size: 0.
> 	name: test.
> event: 2, wd: 1, cookie: 0, len: 61.
> 	tid: 1672.
> 	pid: 1672.
> 	io details: start: 0, size: 6.
> 	name: test.
> 
> Example with only tid and io details:
> $ $ ./iotest -f /tmp/ -t -i
> 2008-11-25 22:40:30.201286 pid: 1928, tid: 1928, name: /tmp/, wd: 1,
> mask: 303, attributes: pid: 0, tid: 1, io: 1, name: 0.
> event: 2, wd: 1, cookie: 0, len: 36.
> 	tid: 1672.
> 	io details: start: 0, size: 0.
> 
> 
> while in parallel I did:
> $ echo qwe11 > /tmp/test
> 
> Two events were sent because of two calls for fsnotify_modify(), invoked
> lkely from attribute change and write. Events are not combined since
> because attributes may be different. Not having a name always combines
> (read: skips next event) events because of old logic.
> 

I guess I'm being more than usually thick, but I don't understand what
this is all about, why it was implemented, what value it provides to
users, etc, etc?  Why do I want scalable nested attributes in inotify??

I'm buried in patches which I don't understand lately, and having
hundreds of people send patches at one guy who doesn't understand them
isn't a good system.  Eric Paris is working on inotify-type things as
well.  It would be neat if you guys were to understand and review each
other's work.  Please.

