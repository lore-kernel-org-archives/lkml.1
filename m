Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756924Ab0BKTuZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Feb 2010 14:50:25 -0500
Received: from mx1.redhat.com ([209.132.183.28]:1993 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756399Ab0BKTuY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Feb 2010 14:50:24 -0500
Message-ID: <4B745F5C.5050001@redhat.com>
Date: Thu, 11 Feb 2010 20:49:48 +0100
From: Michael Stefaniuc <mstefani@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.7) Gecko/20100120 Fedora/3.0.1-1.fc11 Thunderbird/3.0.1
MIME-Version: 1.0
To: Frederic Weisbecker <fweisbec@gmail.com>
CC: "K.Prasad" <prasad@linux.vnet.ibm.com>,
       Alan Stern <stern@rowland.harvard.edu>, linux-kernel@vger.kernel.org,
       Maneesh Soni <maneesh@linux.vnet.ibm.com>,
       Alexandre Julliard <julliard@winehq.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Maciej Rutecki <maciej.rutecki@gmail.com>
Subject: Re: Regression in ptrace (Wine) starting with 2.6.33-rc1
References: <4B743149.4000707@redhat.com> <20100211182224.GC4915@nowhere>
In-Reply-To: <20100211182224.GC4915@nowhere>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/11/2010 07:22 PM, Frederic Weisbecker wrote:
> On Thu, Feb 11, 2010 at 05:33:13PM +0100, Michael Stefaniuc wrote:
>> 2.6.33-rc1 broke ptrace for Wine, specifically the setting of the debug
>> registers. This is visible in the Wine ntdll exception tests failing on
>> 2.6.33-rcX while they work just fine in 2.6.32.
>>
>> A regression test resulted in:
>> 72f674d203cd230426437cdcf7dd6f681dad8b0d is the first bad commit
>> commit 72f674d203cd230426437cdcf7dd6f681dad8b0d
>> Author: K.Prasad<prasad@linux.vnet.ibm.com>
>> Date:   Mon Jun 1 23:45:48 2009 +0530
>>
>>      hw-breakpoints: modify Ptrace routines to access breakpoint registers
>>
>>      This patch modifies the ptrace code to use the new wrapper routines
>> around
>> the
>>      debug/breakpoint registers.
>>
>>      [ Impact: adapt x86 ptrace to the new breakpoint Api ]
>>
>>      Original-patch-by: Alan Stern<stern@rowland.harvard.edu>
>>      Signed-off-by: K.Prasad<prasad@linux.vnet.ibm.com>
>>      Signed-off-by: Maneesh Soni<maneesh@linux.vnet.ibm.com>
>>      Reviewed-by: Alan Stern<stern@rowland.harvard.edu>
>>      Signed-off-by: Frederic Weisbecker<fweisbec@gmail.com>
>>
>> :040000 040000 f72ff4760c3fa1dffcd72494e77bee2c76039505
>> b60d5fe2088ff635568e800d5759a0b373b5e439 M      arch
>>
>>

>> I have opened also http://bugzilla.kernel.org/show_bug.cgi?id=15273 for
>> this.

> Thanks a lot for your report. Is there an easy way to reproduce
> this?
Yes, the bug is 100% reproducible. Even the "stack overflow" bytes are
always constant on my two boxes: 932 bytes on my Atom and 1588 bytes on
my Q9450 with a x86_64 kernel.

Either grab wine-1.1.38 from
http://sourceforge.net/projects/wine/files/Source/ or from git
   git clone git://source.winehq.org/git/wine.git
configure
make
cd dlls/ntdll/tests/
make exception.ok

If you build on an x86_64 machine you'll need a pretty complete 32bit
setup too, but configure will let you know. If configure doesn't errors
out but produces warnings, those can be safely ignored. It means the
dependencies are optional and those aren't needed to reproduce this bug.

Oh, there might be an other regression in ptrace too; introduced by a
previous patch in this series. While bisecting i had a later test fail,
something along the lines of "expected 4 exceptions got 0", but the
tests completed. Now the stack corruption mask everything else in the
tests; e.g. comment out the first test and one of the next tests will go
into an infinite loop printing 3 Wine errors over and over again.

thanks
bye
         michael
