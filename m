Return-Path: <linux-kernel-owner+w=401wt.eu-S1753311AbYAMSZE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753311AbYAMSZE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jan 2008 13:25:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753534AbYAMSYv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Jan 2008 13:24:51 -0500
Received: from mailbox2.myri.com ([64.172.73.26]:1811 "EHLO myri.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753047AbYAMSYu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jan 2008 13:24:50 -0500
Message-ID: <478A5727.3000102@myri.com>
Date: Sun, 13 Jan 2008 13:23:35 -0500
From: Loic Prylli <loic@myri.com>
User-Agent: Thunderbird/2.0.0.4 Mnenhy/0.7.5.0
MIME-Version: 1.0
To: Arjan van de Ven <arjan@infradead.org>
CC: Ivan Kokshaysky <ink@jurassic.park.msu.ru>, Greg KH <greg@kroah.com>,
       Matthew Wilcox <matthew@wil.cx>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org,
       Jeff Garzik <jeff@garzik.org>, linux-pci@atrey.karlin.mff.cuni.cz,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Martin Mares <mj@ucw.cz>, Tony Camuso <tcamuso@redhat.com>
Subject: Re: [Patch v2] Make PCI extended config space (MMCONFIG) a driver
 opt-in
References: <alpine.LFD.1.00.0801111156230.3148@woody.linux-foundation.org>	<20080111201716.GO18741@parisc-linux.org>	<alpine.LFD.1.00.0801111224090.3148@woody.linux-foundation.org>	<20080111204228.GP18741@parisc-linux.org>	<alpine.LFD.1.00.0801111311170.3148@woody.linux-foundation.org>	<20080111211753.GR18741@parisc-linux.org>	<alpine.LFD.1.00.0801111326120.3148@woody.linux-foundation.org>	<20080111213803.GS18741@parisc-linux.org>	<20080111235856.GA16079@jurassic.park.msu.ru>	<20080112002638.GA18710@kroah.com>	<20080112144030.GA19279@jurassic.park.msu.ru> <20080112094557.71f5382a@laptopd505.fenrus.org>
In-Reply-To: <20080112094557.71f5382a@laptopd505.fenrus.org>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 1/12/2008 12:45 PM, Arjan van de Ven wrote:
> On Sat, 12 Jan 2008 17:40:30 +0300
> Ivan Kokshaysky <ink@jurassic.park.msu.ru> wrote:
>   
>>  
>> +	if (reg < 256)
>> +		return pci_conf1_read(seg,bus,devfn,reg,len,value);
>> +
>>     
>
>
> btw this is my main objection to your patch; it intertwines the conf1 and mmconfig code even more.
> When (and I'm saying "when" not "if") systems arrive that only have MMCONFIG for some of the devices,
> we'll have to detangle this again, and I'm really not looking forward to that.
>   


conf1 has been a hardcoded dependencies of mmconfig for years. Ivan's 
patch does not make it worse (in fact it considerably simplifies that 
code, making it easier to untangle later).


IMHO, either your patch or Ivan's can be a good base, but:

1) For your remark above to be given any consideration, your patch 
should be modified to remove the hardcoded conf1 from the *current* 
mmconfig code, otherwise we end up with 3 set of ops (mmconfig + conf1+ 
a possible third set of operations) intertwined in a confusing manner. 
And removing that dependency is not a straightforward operation unless 
you also do 2):

2) the pci_enable_ext_config() function and dev->ext_cfg_space field, 
sysfs interface should be removed from the patch.  There has never been 
a problem reporting crashes or any undefined behaviour while trying to 
access ext-conf-space, all the problems where *using mmconfig to access 
legacy-conf-space*. The "if (dev->cfg_space_ext > 0)" checks can instead 
be replaced by  "if (reg >= 256)".
Otherwise when using per-device explicit enabling, just *checking* 
whether ext-conf-space is available by calling pci_enable_ext_config(), 
will make some of the old problems of *loosing legacy conf-space* come 
back: you would  have introduced a new user-space and kernel API while 
only solving half the problems, not a good deal.

if you do 1) and 2), then you really support the good properties you 
claimed:
- You can use mmconfig for ext-space and something else for legacy-space.
- You can use mmconfig for everything (for instance if conf1 is not 
implemented).

Of course it is as straightforward to modify Ivan's patch to also have 
the same properties.



Loic








Loic

