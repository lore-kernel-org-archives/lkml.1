Return-Path: <linux-kernel-owner+w=401wt.eu-S1758054AbZAWWCm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758054AbZAWWCm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2009 17:02:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755665AbZAWWCd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Jan 2009 17:02:33 -0500
Received: from mail3.caviumnetworks.com ([12.108.191.235]:21843 "EHLO
	mail3.caviumnetworks.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755646AbZAWWCc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2009 17:02:32 -0500
Message-ID: <497A3E62.6010706@caviumnetworks.com>
Date: Fri, 23 Jan 2009 14:02:10 -0800
From: David Daney <ddaney@caviumnetworks.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Florian Weimer <fw@deneb.enyo.de>
CC: linux-kernel@vger.kernel.org, DSA <debian-admin@lists.debian.org>,
       team@security.debian.org, libpam-modules@packages.debian.org
Subject: Re: 2.6.28, rlimits, performance and debian etch
References: <20090121115219.GA2754@anguilla.noreply.org> <8763k5u3xs.fsf@mid.deneb.enyo.de>
In-Reply-To: <8763k5u3xs.fsf@mid.deneb.enyo.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 23 Jan 2009 22:02:10.0177 (UTC) FILETIME=[3D361F10:01C97DA6]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Florian Weimer wrote:
> * Peter Palfrader:
> 
>> Turns out that script is forking a lot and something in it or python or
>> whereever closes all the file descriptors it doesn't want to pass on.
>> That is, it starts at zero and goes up to ulimit -n/RLIMIT_NOFILE and
>> closes them all with a few exceptions.
>>
>> Turns out that takes a long time when your limit -n is now 2^20 (1048576).
> 
> Interesting.
> 
> Can we make /proc more-or-less mandatory, so that the file descriptor
> list can be retrieved explicitly?

One problem is that for values of RLIMIT_NOFILE less than something like 
4096, it is much faster to call sys_close() on all possible values than 
iterate through a handful of open files from /proc/self/fd using 
opendir(3)/readdir(3).

Obviously for some large values of RLIMIT_NOFILE, this is no longer true.

People who have written code based on measuring the difference end up 
getting screwed when RLIMIT_NOFILE unexpectedly increases.

The real solution is to convert your user space programs to use the new 
syscalls that allow for race-free setting of close-on-exec.  Then you no 
longer need to mess around with iterating over these things.

David Daney
