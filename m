Return-Path: <linux-kernel-owner+w=401wt.eu-S1750732AbXBNRKJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750732AbXBNRKJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Feb 2007 12:10:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750739AbXBNRKJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Feb 2007 12:10:09 -0500
Received: from main.gmane.org ([80.91.229.2]:34268 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750732AbXBNRKH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Feb 2007 12:10:07 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: James Antill <james@and.org>
Subject: Re: [PATCH 0 of 4] Generic AIO by scheduling stacks
Date: Wed, 14 Feb 2007 16:42:32 +0000 (UTC)
Message-ID: <eqve5n$dan$1@sea.gmane.org>
References: <patchbomb.1170193181@tetsuo.zabbo.net>
	<Pine.LNX.4.64.0702091419470.8424@woody.linux-foundation.org>
	<20070210.165602.07642259.davem@davemloft.net>
	<Pine.LNX.4.64.0702101841450.8424@woody.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Complaints-To: usenet@sea.gmane.org
X-Gmane-NNTP-Posting-Host: code.and.org
User-Agent: pan 0.120 (Plate of Shrimp)
Cc: linux-aio@kvack.org
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 10 Feb 2007 18:49:56 -0800, Linus Torvalds wrote:

> And I actually talked about that in one of the emails already. There is no 
> way you can beat an event-based thing for things that _are_ event-based. 
> That means mainly networking.
> 
> For things that aren't event-based, but based on real IO (ie filesystems 
> etc), event models *suck*. They suck because the code isn't amenable to it 
> in the first place (ie anybody who thinks that a filesystem is like a 
> network stack and can be done as a state machine with packets is just 
> crazy!).
> 
> So you would be crazy to makea web server that uses this to handle _all_ 
> outstanding IO. Network connections are often slow, and you can have tens 
> of thousands outstanding (and some may be outstanding for hours until they 
> time out, if ever). But that's the whole point: you can easily mix the 
> two, as given in several examples already (ie you can easily make the main 
> loop itself basically do just

 I don't see any replies to this, so here's my 2¢. The simple model of
what a webserver does when sending static data is:

1. local_disk_fd = open()
2. fstat(local_disk_fd)
3. TCP_CORK on
4. send_headers();
5. LOOP
5a. sendfile(network_con_fd, local_disk_fd)
5b. epoll(network_con_fd)
6. TCP_CORK off

...and here's my personal plan (again, somewhat simplified), which I
think will be "better":

7. helper_proc_pipe_fd = DO open() + fstat()
8. read_stat_event_data(helper_proc_pipe_fd)
9. TCP_CORK on network_con_fd
10. send_headers(network_con_fd);
11. LOOP
11a. splice(helper_proc_pipe_fd, network_con_fd)
11b. epoll(network_con_fd && helper_proc_pipe_fd)
12. TCP_CORK off network_con_fd

...where the "helper proc" is doing splice() from disk to the pipe, on the
other end. This, at least in theory, gives you an async webserver and zero
copy disk to network[1]. My assumption is that Evgeniy's aio_sendfile()
could fit into that model pretty easily, and would be faster.

 However, from what you've said above you're only trying to help #1 and #2
(which are likely to be cached in the app. anyway) and apps.
that want to sendfile() to the network either do horrible hacks like
lighttpd's "AIO"[2], do a read+write copy loop with AIO or don't use AIO.


[1] And allows things like IO limiting, which aio_sendfile() won't.

[2] http://illiterat.livejournal.com/2989.html

-- 
James Antill -- james@and.org
http://www.and.org/and-httpd/ -- $2,000 security guarantee
http://www.and.org/vstr/

