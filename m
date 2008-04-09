Return-Path: <linux-kernel-owner+w=401wt.eu-S1757701AbYDIU7x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757701AbYDIU7x (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2008 16:59:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754320AbYDIU7n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Apr 2008 16:59:43 -0400
Received: from relay1.sgi.com ([192.48.171.29]:60740 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750959AbYDIU7m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2008 16:59:42 -0400
Message-ID: <47FD2E3B.5010801@sgi.com>
Date: Wed, 09 Apr 2008 13:59:39 -0700
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Greg KH <gregkh@suse.de>
CC: Bert Wesarg <bert.wesarg@googlemail.com>, Ingo Molnar <mingo@elte.hu>,
       Paul Jackson <pj@sgi.com>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3] x86: add cpus_scnprintf function v3
References: <20080408184301.651388000@polaris-admin.engr.sgi.com> <36ca99e90804091051k7c2cc97neba0ca1967625433@mail.gmail.com> <20080409203909.GA17183@suse.de>
In-Reply-To: <20080409203909.GA17183@suse.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH wrote:
> On Wed, Apr 09, 2008 at 07:51:23PM +0200, Bert Wesarg wrote:
>> On Tue, Apr 8, 2008 at 8:43 PM, Mike Travis <travis@sgi.com> wrote:
>>>   * Cleanup usages of cpumask_scprintf in the following files and add
>>>     another interface to use cpulist_scnprintf where appropriate.
>> On Mon, Apr 7, 2008 at 8:22 PM, Mike Travis <travis@sgi.com> wrote:
>>>  Part of the change is readability, but also looking towards the future
>>>  of 16k/64k/??? # of cpus, the straight mask approach will overflow the
>>>  PAGE_SIZE buffer provided (though some pathological cases will overflow
>>>  the range method as well.)  So we'll need some advancement in the format
>>>  of the printout.
>> Btw, I think you can now push for a deprecation of the 'old' mask
>> attributes, with the justification you have given above. The other
>> possibility is to change sysfs to provide bigger attribute buffers
>> (CCed Greg for this).
> 
> Huh?
> 
> sysfs is "one value per file", if you are getting close to PAGE_SIZE in
> any sysfs file, then you are doing something very wrong.
> 
> What sysfs file currently is trying to output data this big?
> 
> thanks,
> 
> greg k-h

Hi Greg,

There's none at the moment.  The increase is coming from printing the
cpuset for various attributes, like cpus on a node, etc.  Since it uses
cpumask_scnprintf(), this prints a bit map representing a cpumask_t.

With the increase to 4096 cpus, this string is now 1152 bytes long.  The
next iteration will have 16384 cpus which will need 4608 bytes to fully
display, overflowing a standard page.  I've added alternate interfaces
that use cpulist_scnprintf() which has the advantage of collapsing the
bits into ranges.  This though can result in a much larger output size
if, for example only every other bit is set.

Btw, where does one value per file come from?  I see outputs like:

# cat /proc/self/stat
4313 (cat) R 4218 4313 4218 34816 4313 4194304 207 0 0 0 0 0 0 0 20 0 1 0 6802916 5672960 131 18446744073709551615 4194304 4212948 140735962676160 18446744073709551615 140499600349840 0 0 0 0 0 0 0 17 3 0 0 0 0 0

Thanks,
Mike
