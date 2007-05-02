Return-Path: <linux-kernel-owner+w=401wt.eu-S1766970AbXEBUUH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1766970AbXEBUUH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 16:20:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1766977AbXEBUUH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 16:20:07 -0400
Received: from static-72-92-88-10.phlapa.fios.verizon.net ([72.92.88.10]:57181
	"EHLO smtp.roinet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1766970AbXEBUUB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 16:20:01 -0400
Message-ID: <4638F2B2.2000103@roinet.com>
Date: Wed, 02 May 2007 16:21:06 -0400
From: David Acker <dacker@roinet.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070306)
MIME-Version: 1.0
To: Milton Miller <miltonm@bga.com>
CC: Scott Feldman <sfeldma@pobox.com>, Jeff Garzik <jeff@garzik.org>,
       e1000-devel@lists.sourceforge.net, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       John Ronciak <john.ronciak@intel.com>,
       Jesse Brandeburg <jesse.brandeburg@intel.com>,
       Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
       Auke Kok <auke-jan.h.kok@intel.com>
Subject: Re: [PATCH] e100 rx: or s and el bits
References: <200705011124.l41BOEG4007662@sullivan.realtime.net> <46375664.8030701@roinet.com>
In-Reply-To: <46375664.8030701@roinet.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

David Acker wrote:
> Milton Miller wrote:
>> In commit d52df4a35af569071fda3f4eb08e47cc7023f094, the description
>> talks about emulating another driver by setting addtional bits and
>> the being unable to test when submitted.  Seeing the & operator to
>> set more bits made me suspicious, and indeed the bits are defined
>> in positive logic:
>>
>>     cb_s      = 0x4000,
>>     cb_el     = 0x8000,
>>
>> So anding those together would be 0.   I'm guessing they should
>> be or'd, but don't have hardware here to test, much like the
>> committed patch.  In fact, I'll let someone else do the compile
>> test too.  I'll update the comment.
>>
> 
> I wonder if this worked for me because the hardware also spun on the 
> link field being NULL?  Since the RU base is also set to 0, the 
> calculated physical address would be 0 as well.  I would imagine if the 
> hardware tried to read/write to very low addresses across PCI, there 
> would be issues.  I will retest with a small receive pool to try to hit 
> the problem.
> I will also run these tests with the new patch and with a smaller 
> receive pool (default is 256) to make the pool run out more often.

So far my testing has shown both the original and the new version of the 
S-bit patch work in that no corruption seemed to occur over long term 
runs.  The previous S-bit patch may have only worked due to something 
specific about how my PCI companion chip handles I/O to low memory 
addresses (from dereferencing a link address of 0).  Perhaps the e100 
handles the NULL link as well, but given that the manual does not seem 
to state what happens when the hardware encounters a buffer with a link 
of 0, I think Milton's fix is the proper way to do it.  The old eepro 
driver did set both bits although it did it with a hardcoded constant.

I will continue testing with slab debug on but that will take longer. 
Has anyone tried this on other platforms?
-Ack
