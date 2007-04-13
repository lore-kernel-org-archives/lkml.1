Return-Path: <linux-kernel-owner+w=401wt.eu-S1753180AbXDMLtz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753180AbXDMLtz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2007 07:49:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753413AbXDMLtz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Apr 2007 07:49:55 -0400
Received: from outbound-blu.frontbridge.com ([65.55.251.16]:64388 "EHLO
	outbound7-blu-R.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753180AbXDMLty (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2007 07:49:54 -0400
X-BigFish: VP
X-Server-Uuid: 5FC0E2DF-CD44-48CD-883A-0ED95B391E89
Message-ID: <461F6C8C.1020901@amd.com>
Date: Fri, 13 Apr 2007 13:42:04 +0200
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
In-Reply-To: <20070413110313.352330ce@gondolin.boeblingen.de.ibm.com>
X-OriginalArrivalTime: 13 Apr 2007 11:32:24.0143 (UTC)
 FILETIME=[680FA5F0:01C77DBF]
X-WSS-ID: 6A01B5C13284003564-01-01
Content-Type: text/plain;
 charset=iso-8859-1;
 format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Alan,

seems like you have the same problem as the dvb framework has/had.

http://mcentral.de/hg/~mrec/v4l-dvb-stable

The last 3 changesets do the trick to not oops, it will delay the 
deinitialization of the device till the last user closed the device node.

Markus

Cornelia Huck wrote:
> On Thu, 12 Apr 2007 17:23:18 -0400 (EDT),
> Alan Stern <stern@rowland.harvard.edu> wrote:
>
>   
>> Here's a not-so-theoretical question.
>>
>> I've got a module which registers a struct device.  (It represents a
>> virtual device, not a real one, but that doesn't matter.)  Obviously the
>> module's exit routine has to wait until the release() routine for that
>> device has been invoked -- if it returned too early then the release()
>> call would oops.
>>
>> How should it wait?
>>     
>
> Device lifetime vs. module lifetime - that's a fun one...
>
>   
>> The most straightforward approach is to use a struct completion, like 
>> this:
>>
>> 	static struct {
>> 		struct device dev;
>> 		...
>> 	} my_dev;
>>
>> 	static DECLARE_COMPLETION(my_completion);
>>
>> 	static void my_release(struct device *dev)
>> 	{
>> 		complete(&my_completion);
>> 	}
>>
>> 	static void __exit my_exit(void)
>> 	{
>> 		device_unregister(&my_dev.dev);
>> 		wait_for_completion(&my_completion);
>> 	}
>>
>> The problem is that there is no guarantee a context switch won't take
>> place after my_release() has called complete() and before my_release()  
>> returns.  If that happens and my_exit() finishes running, then the module
>> will be unloaded and the next context switch back to finish off
>> my_release() will oops.
>>
>> Other approaches have similar defects.  So how can this problem be solved?
>>     
>
> What I see that a device driver may do now is the following:
> - disallow module unloading (duh)
> - move the release function outside the module
>
> To make the completion approach work, the complete() would need to be
> after the release function. This would imply an upper layer, but this
> upper layer would need to access the completion structure in the
> module...
>
> One could think about a owner field (for getting/putting the module
> reference) for the object (with a final module_put() after the release
> function has been called). The problem there would be that it would
> preclude unloading of the module if there isn't a "self destruct" knob
> for the object.
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
>
>
>
>   


-- 
           |           AMD Saxony Limited Liability Company & Co. KG
 Operating |         Wilschdorfer Landstr. 101, 01109 Dresden, Germany
  System   |                  Register Court Dresden: HRA 4896
 Research  |              General Partner authorized to represent:
  Center   |             AMD Saxony LLC (Wilmington, Delaware, US)
           | General Manager of AMD Saxony LLC: Dr. Hans-R. Deppe, Thomas McCoy




