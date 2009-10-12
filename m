Return-Path: <linux-kernel-owner+w=401wt.eu-S932564AbZJLPN3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932564AbZJLPN3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 11:13:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932508AbZJLPN2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 11:13:28 -0400
Received: from ppsw-7.csi.cam.ac.uk ([131.111.8.137]:49258 "EHLO
	ppsw-7.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932241AbZJLPN1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 11:13:27 -0400
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Message-ID: <4AD3477D.4020904@cam.ac.uk>
Date: Mon, 12 Oct 2009 16:13:01 +0100
From: Jonathan Cameron <jic23@cam.ac.uk>
User-Agent: Thunderbird 2.0.0.23 (X11/20091007)
MIME-Version: 1.0
To: Jean Delvare <khali@linux-fr.org>
CC: LKML <linux-kernel@vger.kernel.org>, Zhang Rui <rui.zhang@intel.com>,
       Rodolfo Giometti <giometti@enneenne.com>,
       "Michele De Candia (VT)" <michele.decandia@valueteam.com>,
       Linux I2C <linux-i2c@vger.kernel.org>
Subject: Re: [PATCH] ALS: TSL2550 driver move from i2c/chips
References: <4ACF4AC6.7070802@cam.ac.uk> <20091010183347.52b043ed@hyperion.delvare>
In-Reply-To: <20091010183347.52b043ed@hyperion.delvare>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jean,
> 
> On Fri, 09 Oct 2009 15:37:58 +0100, Jonathan Cameron wrote:
>> Signed-off-by: Jonathan Cameron <jic23@cam.ac.uk>
>>
>> ---
>> Minimal changes made. Untested due to lack of hardware.
>> All comments welcome.
> 
> Thanks for working on this. I can do any amount of testing you want, as
> I have received a TSL2550 evaluation module from TAOS.
> 
>> illuminance is already documented as part of the class.
>> operating mode and power state are both as per the original
>> driver. I can't find any documentation for them, but if people
>> want it I can probably figure out what they are from
>> the data sheet.
> 
> The operating mode selects the measurable range. Standard range is from
> 0 to 1846 lux, extended range is from 0 to 9230 lux, with a resolution
> divided by 5. Extended mode is also 5 times faster.
> 
> What do we want to do with this? I am open to suggestions. There are
> several possibilities. The operating mode could be provided as platform
> data and stay internal to the driver. Or we can leave is visible to
> user-space, in which case I'd recommend that we do so in terms of
> "range" rather than "mode", so that other drivers can use the same
> convention, whatever it becomes. For example, one would write the range
> of values he/she wants to be able to measure and the driver would put
> the device in the most appropriate mode.
That sounds like a sensible approach.  For now I guess a sysfs parameter
like illuminance_range_max would do the job and we can add a min for any
device that features an offset?
> 
> Alternatively (or additionally), we could implement an automatic mode
> which would change the mode dynamically based on the previous
> measurement. I've done that for one hwmon driver (for fan speed
> measurement) and it works very well, if implemented properly.
Could do.  Maybe put it in as manual for now and leave the automatic
mode for a later date?
> 
>> Might be worth dropping the power state control and moving
>> over to runtime pm but that is definitely the topic for another
>> patch.
> 
> Power state control is already integrated into the PM framework
> (suspend and resume, is there more?) The sysfs entry is to allow a
> manual control on top of it. I don't much like having a custom sysfs
> entry for this, but I don't know if there is a standard way to achieve
> the same?
Not directly as far as I know. The runtime pm is more about buses figuring
out if they can suspend (and take their children into suspend as well).
Personally I haven't looked at the code for those buses that implement it
yet to see exactly how it relates to fine grained control as here.
For now lets leave this as it is with a plan to fix it later.

I do notice that usb supports this sort of control by adding sysfs entries to
the existing power sysfs attribute group.
(curiously I think the relevant one is called level, so we would have
/sys/bus/i2c/devices/*/power/level

We could do the same... 
> 
>> Does anyone want a patch without using Git's move functionality?
> 
> Yes please!
Will post next version. (thanks for the review based on the move version!)
> 
>> Have copied all the users Jean knows about, but please cc any other
>> users as this does involve a change to the userspace interface.
>>
>> Applies on 2.6.31-rc3 with the ALS patches
>> http://patchwork.kernel.org/patch/49153/
>>
>>  drivers/als/Kconfig                  |   14 ++++++
>>  drivers/als/Makefile                 |    2 +
>>  drivers/{i2c/chips => als}/tsl2550.c |   73 ++++++++++++++++++++++++++++++---
>>  3 files changed, 82 insertions(+), 7 deletions(-)
> 

