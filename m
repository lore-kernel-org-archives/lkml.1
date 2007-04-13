Return-Path: <linux-kernel-owner+w=401wt.eu-S1754002AbXDMOGB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754002AbXDMOGB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2007 10:06:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754004AbXDMOGB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Apr 2007 10:06:01 -0400
Received: from outbound-sin.frontbridge.com ([207.46.51.80]:5834 "EHLO
	outbound1-sin-R.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754002AbXDMOGA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2007 10:06:00 -0400
X-BigFish: VP
X-Server-Uuid: 5FC0E2DF-CD44-48CD-883A-0ED95B391E89
Message-ID: <461F9076.4070209@amd.com>
Date: Fri, 13 Apr 2007 16:15:18 +0200
From: "Markus Rechberger" <markus.rechberger@amd.com>
User-Agent: Thunderbird 1.5.0.9 (X11/20070304)
MIME-Version: 1.0
To: "Cornelia Huck" <cornelia.huck@de.ibm.com>
cc: "Alan Stern" <stern@rowland.harvard.edu>,
       "USB development list" <linux-usb-devel@lists.sourceforge.net>,
       "Kernel development list" <linux-kernel@vger.kernel.org>
Subject: Re: How should an exit routine wait for release() callbacks?
References: <Pine.LNX.4.44L0.0704121706040.2472-100000@iolanthe.rowland.org>
 <20070413110313.352330ce@gondolin.boeblingen.de.ibm.com>
 <461F6C8C.1020901@amd.com>
 <20070413152453.571e887a@gondolin.boeblingen.de.ibm.com>
In-Reply-To: <20070413152453.571e887a@gondolin.boeblingen.de.ibm.com>
X-OriginalArrivalTime: 13 Apr 2007 14:05:37.0097 (UTC)
 FILETIME=[CF7D1B90:01C77DD4]
X-WSS-ID: 6A0151B93284015275-01-01
Content-Type: text/plain;
 charset=iso-8859-1;
 format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Cornelia Huck wrote:
> On Fri, 13 Apr 2007 13:42:04 +0200,
> "Markus Rechberger" <markus.rechberger@amd.com> wrote:
>
>   
>> seems like you have the same problem as the dvb framework has/had.
>>
>> http://mcentral.de/hg/~mrec/v4l-dvb-stable
>>
>> The last 3 changesets do the trick to not oops, it will delay the 
>> deinitialization of the device till the last user closed the device node.
>>     
>
> Probably dumb question (since I'm not at all familiar with the dvb
> code): Isn't that a different race you're solving there? I don't see
> any driver core objects involved (except class devices created by
> class_device_create, which obviously don't have the release function
> problem). This looks more like a race of "we want an object to go
> away, but a user still has a file open" (which would be similar to the
> kobject<->sysfs lifetime rules issues, where work is currently ongoing).
>
>   
most dvb usb drivers call the device node unregistration when a device 
gets unplugged (when
At this time the filehandle can still be open, the patch on that site 
sets a flag that disallows
any further access to the device node (in the DVB framework there are 4 
of such nodes)
This can happen any time, so while someone is reading or accessing the 
device some structures
might have gone away already and this could cause an oops.
The problem of the DVB framework is file operation related, the last 
user calls fops_put on the existing
structure and sets the pointer to NULL before it wakes up the other 
function which frees the file operation
structure.
In Alan's case isn't there any users flag available that shows that the 
structure is still beeing accessed?
If that would be the case he could set a flag when he enters my_exit 
which would disable access to all other
functions by returning an error value at the beginning of the other 
functions, the only way out would be
to call my_release for existing users and wake up my_exit when the last 
reference to that structure is gone.

Some more information about the whole driver/scenario would be helpful.

Markus

-- 
           |           AMD Saxony Limited Liability Company & Co. KG
 Operating |         Wilschdorfer Landstr. 101, 01109 Dresden, Germany
 System    |                  Register Court Dresden: HRA 4896
 Research  |              General Partner authorized to represent:
 Center    |             AMD Saxony LLC (Wilmington, Delaware, US)
           | General Manager of AMD Saxony LLC: Dr. Hans-R. Deppe, Thomas McCoy



