Return-Path: <linux-kernel-owner+w=401wt.eu-S1754124AbZEDHn0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754124AbZEDHn0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 May 2009 03:43:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753280AbZEDHnR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 May 2009 03:43:17 -0400
Received: from gw1.cosmosbay.com ([212.99.114.194]:57325 "EHLO
	gw1.cosmosbay.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752334AbZEDHnR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 May 2009 03:43:17 -0400
Message-ID: <49FE9C8C.6090705@cosmosbay.com>
Date: Mon, 04 May 2009 09:43:08 +0200
From: Eric Dumazet <dada1@cosmosbay.com>
User-Agent: Thunderbird 2.0.0.21 (Windows/20090302)
MIME-Version: 1.0
To: Elad Lahav <elahav@uwaterloo.ca>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Implementation of the sendgroup() system call
References: <49FE47A1.7070700@uwaterloo.ca>
In-Reply-To: <49FE47A1.7070700@uwaterloo.ca>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.6 (gw1.cosmosbay.com [0.0.0.0]); Mon, 04 May 2009 09:43:08 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Elad Lahav a écrit :
> The attached patch contains an implementation of sendgroup(), a system
> call that allows a UDP packet to be transmitted efficiently to multiple
> recipients. Use cases for this system call include live-streaming and
> multi-player online games.
> The basic idea is that the caller maintains a group - a list of IP
> addresses and UDP ports - and calls sendgroup() with the group list and
> a common payload. Optionally, the call allows for per-recipient data to
> be prepended or appended to the shared block. The data is copied once in
> the kernel into an allocated page, and the per-recipient socket buffers
> point to that page. Savings come from avoiding both the multiple calls
> and the multiple copies of the data required with regular socket
> operations. We have measured an improvement of 42% in CPU utilisation
> when using this system call with the Helix multimedia server (reference:
> http://simula.no/~griff/nossdav2008/27-32.pdf).
> 
> The patch includes two implementations: one as described above and one
> that uses the udp_sendmsg() function in a tight loop inside the kernel
> (and thus saves on mode switches, but not on data copies). The latter is
> provided for reference and benchmarking only.
> 
> Feedback is welcome.
> 

Hi Elad

Patch is not inlined, this is really asking for troubles, I doubt many people
will actually read your patch...

My comments are :

1) Lack of latency checks. Sending UDP on 1000 destinations is expensive.
  A syscall is not preemptable unless special conditions are met.

2) Lack of a 32/64 bits aware API. A 64bit kernel should be able to 
run a 32bit application using a sendgroup() syscall.

3) Are footer/header differents for each calls ? Maybe you need
  something better to avoid extra copies for them at each sendgroup() systemcall

4) One expensive thing on UDP sends is the route cache lookups. You could avoid
this cost using 'connected' group setup (see point 3)
 
ie using a different syscall to setup the group (and compute/lookup all needed routes)
  (this syscall would be able to add/delete members (with their footer/header) to socket group)
  
Then sendgroup() would be really light, since it would provide a group identifier
(can be a file descriptor -> mapping one group), and the UDP message to send.

