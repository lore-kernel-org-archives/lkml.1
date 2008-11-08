Return-Path: <linux-kernel-owner+w=401wt.eu-S1753323AbYKHR21@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753323AbYKHR21 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Nov 2008 12:28:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753634AbYKHR2S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Nov 2008 12:28:18 -0500
Received: from netgear.net.ru ([195.178.208.66]:59404 "EHLO tservice.net.ru"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750934AbYKHR2R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Nov 2008 12:28:17 -0500
Date: Sat, 8 Nov 2008 20:27:52 +0300
From: Evgeniy Polyakov <zbr@ioremap.net>
To: Robert Love <rlove@rlove.org>
Cc: mtk.manpages@gmail.com, linux-kernel@vger.kernel.org,
       linux-api@vger.kernel.org, John McCutchan <ttb@tentacle.dhs.org>
Subject: Re: [1/1] Use pid in inotify events.
Message-ID: <20081108172752.GA7314@ioremap.net>
References: <20081108114225.GA22674@ioremap.net> <cfd18e0f0811080625w5b285cc0p2410e8d187b025c7@mail.gmail.com> <20081108153545.GA3859@ioremap.net> <cfd18e0f0811080858k7f6cddadg962771ed0cb3bdb8@mail.gmail.com> <acdcfe7e0811080904y7eb461d3n70b0765d8b1e9011@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <acdcfe7e0811080904y7eb461d3n70b0765d8b1e9011@mail.gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

On Sat, Nov 08, 2008 at 12:04:40PM -0500, Robert Love (rlove@rlove.org) wrote:
> The reason John & I did not add a pid field -- and we discussed it and
> really wanted it -- is security. It is an information leak to know
> what an unrelated process is doing.

Really? And receiving notifications about hidden root-only
modified files is ok in this case? :)
Fortunately /proc file creation is not broadcasted via inotify.

I'm talking about following example:

libionotify-1.0$ LD_PRELOAD=./libionotify.so ./inotify -r /tmp
2008-11-08 20:08:19.412222 2478 CREATE: /tmp/test_dir
2008-11-08 20:08:45.725481 2478 CREATE: /tmp/test_dir/test
Failed to add notification for '/tmp/test_dir/test': Permission denied [13].
2008-11-08 20:11:11.424793 2478 CREATE: /tmp/test_dir/another_test
Failed to add notification for '/tmp/test_dir/another_test': Permission denied [13].
2008-11-08 20:11:11.426266 2478 WRITE : /tmp/test_dir/another_test

while in parallel I do:
$ sudo mkdir /tmp/test_dir
$ sudo chown 0.0 /tmp/test_dir
$ sudo chmod 700 /tmp/test_dir
$ sudo touch /tmp/test_dir/test
$ sudo dd if=/dev/zero of=/tmp/test_dir/another_test bs=4k count=1

Permission denied is returned when program tries to add a watch to that objects.

Btw, this means that inotify does not break when permissions are changed
for given object, particulary when read/exec is dropped. This may be a
security problem, since directory listing is forbidden in this case:

$ sudo mkdir /tmp/2
$ cd /tmp/2/
$ sudo chmod 700 .
$ sudo mkdir /tmp/2/test
$ ls
ls: cannot open directory .: Permission denied

Inotify sucessfully prints all created objects...

So, let's not talk about security with PIDs.

> Trust me that the rest of the kernel developers are even harder on
> this subject than I.
> 
> I suppose you could fill out the pid field only if the uid's match,
> but that is extra work for less utility.

Well... Although I could not call this 'security', but yes, it can be
done for root and when uids match. This will solve my particular problem
where server with multiple threads should differentiate between own
writes and local writes from other processes.

-- 
	Evgeniy Polyakov
