Return-Path: <linux-kernel-owner+w=401wt.eu-S1757086AbYAFUST@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757086AbYAFUST (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jan 2008 15:18:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754016AbYAFUSM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Jan 2008 15:18:12 -0500
Received: from e4.ny.us.ibm.com ([32.97.182.144]:49176 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753029AbYAFUSL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jan 2008 15:18:11 -0500
Message-ID: <4781377F.7040105@vnet.ibm.com>
Date: Sun, 06 Jan 2008 14:18:07 -0600
From: Tom Gall <tom_gall@vnet.ibm.com>
User-Agent: Mozilla Thunderbird 1.0.7 (Macintosh/20050923)
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: tomlanyon@gmail.com, linux-kernel@vger.kernel.org
Subject: Re: runaway loop modprobe binfmt-0000
References: <477D26EB.6070008@vnet.ibm.com> <20080105013023.5c872c79.akpm@linux-foundation.org>
In-Reply-To: <20080105013023.5c872c79.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew,

Thanks for the email back.

Andrew Morton wrote:

>On Thu, 03 Jan 2008 12:18:19 -0600 Tom Gall <tom_gall@vnet.ibm.com> wrote:
>  
>
>>This is an interesting one as I just hit this with a 2.6.23.12 kernel 
>>...  granted running on systemsim (the powerpc simulator) ... but as I'm 
>>hitting a wall I dropped in the dump_stack call and here is the output:
>>    
>>
>
>I don't remember what any of this is about and there is no record on the
>mailing list - presumably because you're ccing lkml@vger.kernel.org and not
>linux-kernel@...
>  
>
Ever written the previous year on your checks? Well when I was googling 
about for folks with similar woes, the posts I had thought were from 
this January were actually from Jan 2007.  O Well! Not to mention it's 
been awhile since I've posted to lkml ....

>I suggest that we start again with this bug report from scratch.  
>  
>
In this case, not needed. I spent friday taking a tour of the codepath 
and basically narrowed it down to a device driver passing bum data.

So if this ever happens in the future and someone somewhere seems the 
message about trying to load binfmt-xxxx (where xxxx is 0000 or some 
other "random" number * (hold that thought I'll come back to this) ) 
here are some things to consider as you're debugging your problem.

In my case, the device driver was just good enough that it could access 
the device, but was poor enough that the bits it was loading were 
complete crap ...   So the kernel was happily running along booting, 
gets to the point where it's time to exec init, loads the first bits of 
the binary, does a compare to make sure it's an elf binary, fails the 
compare (because the data is junk) ...  the kernel figures that ooo .. 
this data must be good it's just in a different format ... I'll run 
through the list of known binary file formats.. hmm not that one .. or 
that one ....   then running out of options trys to load a module for 
what must be this amazing new file format, can't find the module and 
ker-blew-ee.

* So this number that is part of the module name binfmt-xxxx is from 
what I see the id of the file format ... thankfully no one has choosen 
0000 as their id ...

>Unless it's a potential denial-of-service attack for unprivileged users,
>in which case a cc to security@vger.kernel.org migt be more appropriate.
>  
>
As this is a boot time issue it's certainly not a DOS.  Now there might 
be value is thinking about this error path in the initial boot up of the 
kernel. The message is a bit obscure for what the real issue is. Still 
.. should one go back to the device and comfirm that the data received 
was actually reasonable? No.

So I think we have two cases here:

Bootup:
I could see a change where the system should probably panic with some 
sort of message like : "Not able to exec %s, unrecognized file format" 
if this were to happen at boot up.  I could put together a patch.

Running System:
If this happens after the system is up and running, I'd think one is 
going to have some data in dmeg probably to the tune of "media error" 
... so in my mind, who cares about that case.

Regards,

Tom


