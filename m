Return-Path: <linux-kernel-owner+w=401wt.eu-S1756454AbYA2WPn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756454AbYA2WPn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2008 17:15:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752333AbYA2WPe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jan 2008 17:15:34 -0500
Received: from crazy.xmat.net ([91.121.11.163]:49236 "EHLO
	tchaikovsky.artsenscene.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752156AbYA2WPd convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2008 17:15:33 -0500
To: greg@kroah.com, markus.rechberger@amd.com
Subject: Re: FW: 2.6.24 breaks BIOS updates on all Dell machines
X-IlohaMail-Blah: khali@gcu-squad.org
X-IlohaMail-Method: mail() [mem]
X-IlohaMail-Dummy: moo
X-Mailer: IlohaMail/0.8.14 (On: mail.gcu-squad.org)
Message-ID: <xJSmDwPr.1201644922.4322840.khali@gcu-squad.org>
In-Reply-To: <20080129184129.GA23681@kroah.com>
From: "Jean Delvare" <khali@linux-fr.org>
Bounce-To: "Jean Delvare" <khali@linux-fr.org>
CC: "Matt_Domsch@dell.com" <Matt_Domsch@dell.com>,
       "Jos?? Luis Tall??n" <jltallon@adv-solutions.net>,
       "Douglas_Warzecha@dell.com" <Douglas_Warzecha@dell.com>,
       "Abhay_Salunke@dell.com" <Abhay_Salunke@dell.com>,
       linux-kernel@vger.kernel.org,
       "Michael E Brown" <Michael_E_Brown@dell.com>,
       "Greg KH" <gregkh@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Date: Tue, 29 Jan 2008 23:15:22 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Greg,

Le 29/1/2008, "Greg KH" <greg@kroah.com> a écrit:

>On Tue, Jan 29, 2008 at 03:59:44PM +0100, Markus Rechberger wrote:
>>> -----Original Message-----
>>> (...)
>>> On Tue, Jan 29, 2008 at 12:32:44AM -0600, Michael E Brown wrote:
>>>
>>>> BIOS updates are broken on all Dell systems due to Commit
>>>> 109f0e93b6b728f03c1eb4af02bc25d71b646c59, which is now in 2.6.24.
>>>>
>>>>   static inline void fw_setup_device_id(struct device *f_dev, struct
>>>> device *dev)
>>>>   {
>>>> -       /* XXX warning we should watch out for name collisions */
>>>> -       strlcpy(f_dev->bus_id, dev->bus_id, BUS_ID_SIZE);
>>>> +       snprintf(f_dev->bus_id, BUS_ID_SIZE, "firmware-%s",
>>>> dev->bus_id);
>>>>  }
>>>>
>> reverting this breaks support for several media (DVB/V4L) devices. I would
>> have to look up some bugreports the same name collision happened with
>> several different drivers.
>> There was a comment in the fw code to watch out for name collisions earlier
>> already, so it needs a fix somewhere.
>>
>> Here's some history:
>> http://mcentral.de/wiki/index.php5/Bugtracker#i2c_dev_problem
>
>Yes, but we can't break existing code that has been working for quite
>some time.  That's just unacceptable.  The i2c devices can fix things by
>changing their module names so this collision doesn't happen :)

Actually, the i2c-dev driver was there before the firmware class, so if
anything, the firmware class broke something that was working before. It
just happens that nobody really needs to poke at the i2c-dev sysfs
directories, while user-space tools need to access firmware sysfs
directories. And most people do not need i2c-dev at all.

Also note that the way firmware directories were originally named (by the
name of the device itself!) wasn't exactly smart and was calling for
confusion if not trouble IMHO.

>So, I'm all for reverting this patch.
>
>And then, feel free to revisit the problem by proposing something that
>doesn't break existing users of the interface.

I'm a bit confused. It seems to me that the "class devices" are named
differently in recent kernels. The i2c-dev class devices were originally
showing as i2c-%d in their parent device directories (causing the
collision), and now show as i2c-dev:i2c-%d. This suggests that the
collision the patch above was trying to solve is in fact already fixed
(by prefixing the device name with the class name). The good news is
that it would mean that we can just revert the patch in question...

But quite frankly I'm not really sure, the class devices look different
on every kernel I looked at, depending on the version and whether
CONFIG_SYSFS_DEPRECATED is set or not.

--
Jean Delvare
