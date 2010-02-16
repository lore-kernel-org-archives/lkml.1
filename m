Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753199Ab0BPLB6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Feb 2010 06:01:58 -0500
Received: from ppsw-1.csi.cam.ac.uk ([131.111.8.131]:56377 "EHLO
	ppsw-1.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750971Ab0BPLB4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Feb 2010 06:01:56 -0500
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Message-ID: <4B7A7B8F.9080501@cam.ac.uk>
Date: Tue, 16 Feb 2010 11:03:43 +0000
From: Jonathan Cameron <jic23@cam.ac.uk>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20100109 Thunderbird/3.0
MIME-Version: 1.0
To: Greg KH <gregkh@suse.de>
CC: Mike Frysinger <vapier.adi@gmail.com>, Kay Sievers <kay.sievers@vrfy.org>,
       LKML <linux-kernel@vger.kernel.org>, Dmitry Torokhov <dtor@mail.ru>,
       "Hennerich, Michael" <Michael.Hennerich@analog.com>,
       Manuel Stahl <manuel.stahl@iis.fraunhofer.de>,
       Robin Getz <rgetz@blackfin.uclinux.org>,
       "Trisal, Kalhan" <kalhan.trisal@intel.com>,
       "Zhang, Xing Z" <xing.z.zhang@intel.com>,
       Ira Snyder <iws@ovro.caltech.edu>, Jean Delvare <khali@linux-fr.org>,
       Samu Onkalo <samu.p.onkalo@nokia.com>,
       Stefani Seibold <stefani@seibold.net>
Subject: Re: [RFC] Staging: IIO: New ABI V2
References: <4B6C619C.3000302@cam.ac.uk> <201002151526.53539.rgetz@blackfin.uclinux.org> <8bd0f97a1002151658l742444cg18b2a38846cbfe37@mail.gmail.com> <20100216024924.GA29008@suse.de>
In-Reply-To: <20100216024924.GA29008@suse.de>
X-Enigmail-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/16/10 02:49, Greg KH wrote:
> On Mon, Feb 15, 2010 at 07:58:12PM -0500, Mike Frysinger wrote:
>> On Mon, Feb 15, 2010 at 15:26, Robin Getz wrote:
>>> On Fri 5 Feb 2010 13:21, Jonathan Cameron pondered:
>>>> Here is another iteration of the ABI spec for IIO with changes made
>>>> in response to http://lkml.org/lkml/2010/1/20/195 and
>>>> http://marc.info/?l=lm-sensors&m=126496271320649&w=2 along with a few
>>>> other general tidy ups.
>>>>
>>>> If there are no major issues raised, we may begin working on the move
>>>> to this ABI shortly on the basis any minor changes can always get
>>>> cleaned up before those patches merge. ??I'll also be doing a formal
>>>> version of this file for in kernel documentation once things are
>>>> fairly stable with all of the information not relevant to this
>>>> discussion.
>>>>
>>>> Changes since v1:
>>>>
>>>> * iio is now a bus with directory changes resulting in this document.
>>>> * moved to in0_raw etc for voltage sensors to avoid confusion with
>>>> ?? a completely different ABI from hwmon. ??Jean made the point that
>>>> ?? we shouldn't take this to far, but as things currently stand there
>>>> ?? is no disadvantage in this name change.
>>>> * dropped freefall event for now. More discussions need to be had on this
>>>> ?? and in a straight IIO world we normally won't care about this one anyway.
>>>> * 'device' naming changed for the various subsidiary devices so as make
>>>> ?? the interconnections more obvious. ??I haven't tried implementing this
>>>> ?? yet, but I think the small amount of pain involved is worth it for
>>>> ?? increased clarity. The only exception is triggers where the connections
>>>> ?? are not specified as a given trigger may not have and IIO device
>>>> ?? associated with it. ??Anyone suggest a scheme for this? (see about 10
>>>> ?? lines below to clarify what I mean here!)
>>>> * As conversion of the max1363 driver over to a consistent scan_element
>>>> ?? interface will mean that these will only apply to the ring buffer
>>>> ?? (rather than direct capture), scan_elements is moved into the ring
>>>> ?? buffer device directory.
>>>> * Switch ring for simply buffer as it might be a fifo or other buffer
>>>> ?? form instead.
>>>>
>>>> At times I may have suppressed links that would be created by the tree of
>>>> devices. In the flat base directory a given driver can now create the
>>>> following:
>>>>
>>>> device[n]
>>>> device[n]:ring
>>>> device[n]:ring:access
>>>> device[n]:ring:event
>>>> device[n]:event[m]
>>>> trigger[o]
>>>>
>>>
>>> What exists today still requires a copy_[to|from]_user when using the ring
>>> buffer (and then another cache_flush if you are dma'ing things). These seems
>>> pretty expensive and will consume extra cycles that will limit throughput.
>>>
>>> Any thoughts to a mmaped interface directly to the IIO ring buffer, so the
>>> system could avoid some of the above overhead? (This is what we had to do for
>>> some other drivers - which were able to handle a 40 MSample/second data
>>> processed by userspace for a soft radio).
>>
>> does sysfs currently support mmap-ing of files in there ?
> 
> For binary files, yes.  If you are going to use mmap, use a character
> device node instead please, that's not what sysfs is for.
All the buffer access is done via character device nodes anyway.

For anyone entering the discussion at this point:
Only really simple IIO drivers (for typically very slow devices)
are principally accessed through sysfs.  For these fast devices we
probably wouldn't provide that route at all, merely using sysfs to
describe the parameters of the device and buffer being used.

Jonathan
