Return-Path: <linux-kernel-owner+w=401wt.eu-S1758017AbYDUTBp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758017AbYDUTBp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2008 15:01:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753673AbYDUTBe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Apr 2008 15:01:34 -0400
Received: from fg-out-1718.google.com ([72.14.220.153]:9687 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753567AbYDUTBd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2008 15:01:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=VXtmif8wVwyu+PW66WeOQEt183QECsyusP9ZHe0JYcxZSS3cYsLg862PdyEvgaH7NHF81uiXRFdPqyKGcgSUpf8dX5/OmI+KKE6so6K0xczIHBAUCPMcLoEga8F1H/VSpAj8BPQUOsAoVfKLWOHCTV7V/mBO+A+BY11UwHEvPlE=
Date: Mon, 21 Apr 2008 23:56:50 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Chris Snook <csnook@redhat.com>
Cc: Jay Cliburn <jacliburn@bellsouth.net>,
       Luca Tettamanti <kronos.it@gmail.com>, Jeff Garzik <jeff@garzik.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org, Christoph Lameter <clameter@sgi.com>,
       torvalds@osdl.org
Subject: Re: atl1 64-bit => 32-bit DMA borkage (reproducible, bisected)
Message-ID: <20080421195650.GA4761@martell.zuzino.mipt.ru>
References: <Pine.LNX.4.64.0804141301580.7803@schroedinger.engr.sgi.com> <20080419111719.GA6724@martell.zuzino.mipt.ru> <20080419144535.GA4814@martell.zuzino.mipt.ru> <20080419215444.2d4623f5@osprey.hogchain.net> <20080420111453.GA4902@martell.zuzino.mipt.ru> <20080420060607.2b1be48b@osprey.hogchain.net> <20080420122631.GA4761@martell.zuzino.mipt.ru> <20080420133704.63f5cc10@osprey.hogchain.net> <20080420205500.GA4762@martell.zuzino.mipt.ru> <480CE022.2080601@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <480CE022.2080601@redhat.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 21, 2008 at 02:42:42PM -0400, Chris Snook wrote:
> Alexey Dobriyan wrote:
>> On Sun, Apr 20, 2008 at 01:37:04PM -0500, Jay Cliburn wrote:
>>> On Sun, 20 Apr 2008 16:26:31 +0400
>>> Alexey Dobriyan <adobriyan@gmail.com> wrote:
>>>
>>>> On Sun, Apr 20, 2008 at 06:06:07AM -0500, Jay Cliburn wrote:
>>>>> On Sun, 20 Apr 2008 15:14:53 +0400
>>>>> Alexey Dobriyan <adobriyan@gmail.com> wrote:
>>>>>
>>>>>> On Sat, Apr 19, 2008 at 09:54:44PM -0500, Jay Cliburn wrote:
>>>>>>> On Sat, 19 Apr 2008 18:45:35 +0400
>>>>>>> Alexey Dobriyan <adobriyan@gmail.com> wrote:
>>> [...]
>>>>>>>> So, it's enough to scp 200 MB git archive and immediately
>>>>>>>> start rebooting sequence for horrors described above to
>>>>>>>> appear. It's not 100% reproducible but more like 90%.
>>>>>>> Do I understand correctly that these failures occur only while
>>>>>>> the network interface is going down?
>>>>>> Yep. During up or running there were no problems with this card.
>>>>>>
>>>>> One more question:  Does it happen whether or not you're using atl1
>>>>> as a netconsole?
>>>> Without netconsole bugs happens too.
>>>>
>>> I can't duplicate this error, but it's probably because my machine
>>> doesn't have 4GB of memory.
>>>
>>> I have one report in Febroary 2008 of another user encountering strange
>>> oopses in 2.6.23.12 and 2.6.24 whenever he downed the interface.  I
>>> suspect your experience is a repeat of that.
>>>
>>> Just to be clear, you transfer about 200MB to the NIC (Rx direction),
>>> then immediately reboot, right?
>> Yup!
>>> Can you duplicate the problem if you
>>> simply ifconfig down instead of rebooting after the transfer?  
>> Aha, ifconfig down is enough. Here is how reproducer looks like now:
>> 	./sync-linux-linus && ssh core2 "sudo /sbin/ifconfig eth0 down"
>> where first script is basically scp(1).
>> Also, booting with 1G or 2G of RAM (mem=1024m) makes issue go away.
>> printk at dev_close() time shows that NETIF_F_HIGHDMA was not somehow
>> enabled.
>
> Does the problem go away with iommu=nomerge?  If so, I suspect we're not 
> properly flushing an iowrite somewhere.

nomerge doesn't help.

