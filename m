Return-Path: <linux-kernel-owner+w=401wt.eu-S1755024AbYF2Xym@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755024AbYF2Xym (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jun 2008 19:54:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752162AbYF2Xyc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Jun 2008 19:54:32 -0400
Received: from mail.tmr.com ([64.65.253.246]:46045 "EHLO gaimboi.tmr.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752064AbYF2Xyb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jun 2008 19:54:31 -0400
Message-ID: <48682186.5030002@tmr.com>
Date: Sun, 29 Jun 2008 19:57:58 -0400
From: Bill Davidsen <davidsen@tmr.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.8) Gecko/20061105 SeaMonkey/1.0.6
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: Avi Kivity <avi@qumranet.com>,
       =?ISO-8859-1?Q?T=F6r=F6k_Edwin?= <edwintorok@gmail.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: Ctrl+C doesn't interrupt process waiting for I/O
References: <48661488.10304@gmail.com> <4866F6FE.9000503@goop.org> <486704AC.2090207@qumranet.com> <48671A12.90205@goop.org> <48671FF6.1070501@qumranet.com> <48672ADE.1090300@goop.org>
In-Reply-To: <48672ADE.1090300@goop.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremy Fitzhardinge wrote:
> Avi Kivity wrote:
>> Applications should not assume that write() (or other syscalls) can't 
>> return EINTR.  Not all filesystems have a bounded-time backing store.
> 
> The distinction between 'fast' (filesystem) and 'slow' (terminals and 
> pipes) blocking syscalls goes back to the earliest days of Unix, and is 
> part of the ABI.  Most filesystem syscalls are not documented to ever 
> return EINTR.
> 
>> 'soft' has its own problems; namely false positives when someone steps 
>> on the network cable, temporarily blocking packet flow, or when using 
>> a clustered server which may take some time to recover from a fault.
> 
> Sure.  It's the basic problem of trying to make network access 
> transparent by hiding the failure modes.  You either need to put up with 
> spurious timeouts caused by transient failures, or unbounded blocking on 
> real failures.
> 
Basic problem is that you can get a process which you can't interrupt 
(in in most cases can't kill) which has resources tied up. Given the 
choice between surprising a process with an EINTR or killing it during a 
reboot to get the system usable again, I would rather surprise.

The current situation is infrequent but not unheard of. And the causes 
are not all rooted in NFS, I used to see this 4-5 times a year when I 
was running nntp clusters with heavily threaded applications, every once 
in a while some thread would hang in a waiting for i/o state and could 
be killed or fixed. I can't see that an application error would result 
in a thread being left waiting i/o and uninterruptable, that's a kernel 
state.

-- 
Bill Davidsen <davidsen@tmr.com>
   "We have more to fear from the bungling of the incompetent than from
the machinations of the wicked."  - from Slashdot
