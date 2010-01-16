Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758223Ab0APAdT (ORCPT <rfc822;list-kernel77@spinics.net>);
	Fri, 15 Jan 2010 19:33:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757176Ab0APAdS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jan 2010 19:33:18 -0500
Received: from hera.kernel.org ([140.211.167.34]:51205 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753077Ab0APAdR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jan 2010 19:33:17 -0500
Message-ID: <4B510902.70301@kernel.org>
Date: Fri, 15 Jan 2010 16:32:02 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091130 SUSE/3.0.0-1.1.1 Thunderbird/3.0
MIME-Version: 1.0
To: Jesse Barnes <jbarnes@virtuousgeek.org>
CC: Ingo Molnar <mingo@elte.hu>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
        Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
        Alex Chiang <achiang@hp.com>, Bjorn Helgaas <bjorn.helgaas@hp.com>,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org
Subject: Re: [PATCH 07/14] pci: don't shrink bridge resources
References: <1261522954-12591-1-git-send-email-yinghai@kernel.org>	<1261522954-12591-8-git-send-email-yinghai@kernel.org>	<20100115110448.379959ad@jbarnes-piketon>	<4B50D98B.3000801@kernel.org> <20100115133155.3bc1960c@jbarnes-piketon>
In-Reply-To: <20100115133155.3bc1960c@jbarnes-piketon>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/15/2010 01:31 PM, Jesse Barnes wrote:
> On Fri, 15 Jan 2010 13:09:31 -0800
> Yinghai Lu <yinghai@kernel.org> wrote:
> 
>> On 01/15/2010 11:04 AM, Jesse Barnes wrote:
>>> On Tue, 22 Dec 2009 15:02:27 -0800
>>> Yinghai Lu <yinghai@kernel.org> wrote:
>>>
>>>> when we are clearing leaf bridge resource and try to get big one,
>>>> we could shrink the bridge if there is no resource under it.
>>>>
>>>> let check with old resource size and make sure we are trying to get
>>>> big one.
>>>>
>>>> -v2: keep disable window print out, still could happen on non pci
>>>> hotplug system
>>>>
>>>> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
>>>> ---
>>>>  drivers/pci/setup-bus.c |   14 ++++++++++++--
>>>>  1 files changed, 12 insertions(+), 2 deletions(-)
>>>>
>>>> diff --git a/drivers/pci/setup-bus.c b/drivers/pci/setup-bus.c
>>>> index 9bb4435..d53b42e 100644
>>>> --- a/drivers/pci/setup-bus.c
>>>> +++ b/drivers/pci/setup-bus.c
>>>> @@ -387,7 +387,7 @@ static void pbus_size_io(struct pci_bus *bus,
>>>> resource_size_t min_size) {
>>>>  	struct pci_dev *dev;
>>>>  	struct resource *b_res = find_free_bus_resource(bus,
>>>> IORESOURCE_IO);
>>>> -	unsigned long size = 0, size1 = 0;
>>>> +	unsigned long size = 0, size1 = 0, old_size;
>>>>  
>>>>  	if (!b_res)
>>>>   		return;
>>>> @@ -412,12 +412,17 @@ static void pbus_size_io(struct pci_bus *bus,
>>>> resource_size_t min_size) }
>>>>  	if (size < min_size)
>>>>  		size = min_size;
>>>> +	old_size = resource_size(b_res);
>>>> +	if (old_size == 1)
>>>> +		old_size = 0;
>>>
>>> Do we even need these == 1 checks?  If old_size really was 1, it
>>> means we had a very small decode range.  Might make more sense to
>>> do...
>>
>> when start=0 and end =0, will get old_size = 1
> 
> ...
> if (old_size == 1)
>   old_size = 0
> ...
> if (size < old_size)
>   size = old_size
> ...
> 
> 
> If old_size > 1 we'll make sure size doesn't decrease.
> 
> If old_size == 1, we'll never touch the changed size because size < 0
> will never be true for size (unsigned).
> 
> However, if old_size == 1 and we left it at 1, we'd only set size =
> old_size if size was 0, which is why I suggested the size check.
> 

but:
for
if (size && size < old_size)

if the new one will 0 ( no device under it and it is not hotplug supported <so min_size = 0> )
then we will overwrite the real old size...during second try.

YH
