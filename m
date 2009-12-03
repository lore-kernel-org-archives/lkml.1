Return-Path: <linux-kernel-owner+w=401wt.eu-S1756078AbZLCOhC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756078AbZLCOhC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Dec 2009 09:37:02 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755939AbZLCOhA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Dec 2009 09:37:00 -0500
Received: from out01.mta.xmission.com ([166.70.13.231]:34845 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751053AbZLCOhA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Dec 2009 09:37:00 -0500
To: Clemens Ladisch <clemens@ladisch.de>
Cc: markh@compro.net, Mai Daftedar <mai.daftedar@gmail.com>,
       linux-kernel@vger.kernel.org
References: <2cd4ff050912010307h5570a376xc220a95947775eae@mail.gmail.com>
	<4B151A86.1060505@ladisch.de> <4B1533B0.1030007@compro.net>
	<4B165D71.5010408@ladisch.de>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Thu, 03 Dec 2009 06:36:58 -0800
In-Reply-To: <4B165D71.5010408@ladisch.de> (Clemens Ladisch's message of "Wed\, 02 Dec 2009 13\:28\:33 +0100")
Message-ID: <m17ht4ktth.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Mail-From: ebiederm@xmission.com
Subject: Re: Signal from kernel space to user space
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: No (on in01.mta.xmission.com); Unknown failure
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Clemens Ladisch <clemens@ladisch.de> writes:

> Mark Hounschell wrote:
>> Clemens Ladisch wrote:
>> > kill_pid_(info) is to be preferred over send_sig_info because it ensures
>> > that the destination process has the same identity (a plain pid number
>> > might have wrappend around and be in use by another process).
>> 
>> Does that mean I can't assume my process pid will unique for the life of the process?
>
> The pid _does_ uniquely identify your process.  However, after the
> process has died, it could be used for some new process, and
> send_sig_info would happily kill the new process.

send_sig_info isn't that bad as it takes a task struct.

Plain pid_t's are just broken to use.

A pid_t uniquely identifies a process within a pid namespace, not within
all of the pid namespaces present on the kernel.


>> > However, why are you using a signal? What information are you trying to
>> > send, and why wouldn't eventfd or a plain device thaz becomes readable
>> > be a better solution?
>> 
>> If no "information" is required, which of these are the fastest, say
>> from an interrupt handler?
>
> If there really is no information, doing nothing would be fastest.  ;-)

That or simply waking up the task. 

> If you want to tell userland that some event has happened, the various
> mechanisms are not much different as far as the kernel is concerned,
> as long as you don't have many thousands of events per seconds; the
> biggest problems for event delivery are scheduling the userland process
> for execution and handling of the event.
>
> Signals handlers interrupt any other userland code and therefore are
> not allowed to do much; therefore, I would strongly prefer to use
> some file handle that can be waited on with poll().  Furthermore,
> poll() allows to wait for multiple handles, and does not have the
> complexities of signal delivery and blocking.  I would use signals only
> if the handler must interrupt any other running code, and if the signal
> can be handled completely without running into reentrancy problems.

Plus signals have all kinds of weird latency and overhead.

Outside of core kernel code, or subsystems where they are already used I
would be surprised if signals could be done correctly and usefully.  pid
rollover isn't the only hidden gotcha.

Eric
