Return-Path: <linux-kernel-owner+w=401wt.eu-S1762295AbXJZB0S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762295AbXJZB0S (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2007 21:26:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753278AbXJZB0A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Oct 2007 21:26:00 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:58786 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752633AbXJZBZ7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2007 21:25:59 -0400
Message-ID: <47214223.40909@garzik.org>
Date: Thu, 25 Oct 2007 21:25:55 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
CC: LKML <linux-kernel@vger.kernel.org>, linux-ide@vger.kernel.org,
       akpm@linux-foundation.org
Subject: Re: [PATCH 2/3] drivers/ide/pci/sc1200.c: remove pointless hwif lookup
 loop
References: <09821349085390234lkjasdflkjasflkdj24746@havoc.gtf.org> <20071024234823.6D1461F819D@havoc.gtf.org> <200710252201.59039.bzolnier@gmail.com>
In-Reply-To: <200710252201.59039.bzolnier@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Bartlomiej Zolnierkiewicz wrote:
> On Thursday 25 October 2007, Jeff Garzik wrote:
>> Store our hwif indices at probe time, in order to eliminate a needless
>> and ugly loop across all hwifs, searching for our pci device.
> 
> It seems that we can simplify it even further and remove knowledge about
> hwifs altogether from suspend/resume methods.
> 
>> Signed-off-by: Jeff Garzik <jgarzik@redhat.com>
>> ---
>>  drivers/ide/pci/sc1200.c |   76 +++++++++++++++++++++++++++++++---------------
>>  1 files changed, 51 insertions(+), 25 deletions(-)
>>
>> diff --git a/drivers/ide/pci/sc1200.c b/drivers/ide/pci/sc1200.c
>> index d2c8b55..17e58d6 100644
>> --- a/drivers/ide/pci/sc1200.c
>> +++ b/drivers/ide/pci/sc1200.c
>> @@ -41,6 +41,8 @@
>>  #define PCI_CLK_66	0x02
>>  #define PCI_CLK_33A	0x03
>>  
>> +#define SC1200_IFS	4
>> +
>>  static unsigned short sc1200_get_pci_clock (void)
>>  {
>>  	unsigned char chip_id, silicon_revision;
>> @@ -261,31 +263,32 @@ static void sc1200_set_pio_mode(ide_drive_t *drive, const u8 pio)
>>  }
>>  
>>  #ifdef CONFIG_PM
>> -static ide_hwif_t *lookup_pci_dev (ide_hwif_t *prev, struct pci_dev *dev)
>> -{
>> -	int	h;
>> -
>> -	for (h = 0; h < MAX_HWIFS; h++) {
>> -		ide_hwif_t *hwif = &ide_hwifs[h];
>> -		if (prev) {
>> -			if (hwif == prev)
>> -				prev = NULL;	// found previous, now look for next match
>> -		} else {
>> -			if (hwif && hwif->pci_dev == dev)
>> -				return hwif;	// found next match
>> -		}
>> -	}
>> -	return NULL;	// not found
>> -}
>> -
>>  typedef struct sc1200_saved_state_s {
>>  	__u32		regs[4];
>>  } sc1200_saved_state_t;
>>  
>> +static unsigned int pack_hwif_idx(u8 *idx)
>> +{
>> +	return	(((unsigned int) idx[0]) << 0) |
>> +		(((unsigned int) idx[1]) << 8) |
>> +		(((unsigned int) idx[2]) << 16) |
>> +		(((unsigned int) idx[3]) << 24);
>> +}
>> +
>> +static ide_hwif_t *sc1200_hwif(struct pci_dev *pdev, unsigned int iface)
>> +{
>> +	unsigned int packed_hwifs, idx;
>> +
>> +	packed_hwifs = (unsigned long) pci_get_drvdata(pdev);
>> +	idx = (packed_hwifs >> (iface * 8)) & 0xff;
>> +
>> +	return (idx == 0xff) ? NULL : &ide_hwifs[idx];
>> +}
>>  
>>  static int sc1200_suspend (struct pci_dev *dev, pm_message_t state)
>>  {
>> -	ide_hwif_t		*hwif = NULL;
>> +	ide_hwif_t		*hwif;
>> +	int			i;
>>  
>>  	printk("SC1200: suspend(%u)\n", state.event);
>>  
>> @@ -295,9 +298,14 @@ static int sc1200_suspend (struct pci_dev *dev, pm_message_t state)
>>  		//
>>  		// Loop over all interfaces that are part of this PCI device:
>>  		//
>> -		while ((hwif = lookup_pci_dev(hwif, dev)) != NULL) {
>> +		for (i = 0; i < SC1200_IFS; i++) {
>>  			sc1200_saved_state_t	*ss;
>>  			unsigned int		basereg, r;
>> +
>> +			hwif = sc1200_hwif(dev, i);
>> +			if (!hwif)
>> +				continue;
>> +
>>  			//
>>  			// allocate a permanent save area, if not already allocated
>>  			//
>> @@ -310,7 +318,7 @@ static int sc1200_suspend (struct pci_dev *dev, pm_message_t state)
>>  			}
>>  			ss = (sc1200_saved_state_t *)hwif->config_data;
>>  			//
>> -			// Save timing registers:  this may be unnecessary if 
>> +			// Save timing registers:  this may be unnecessary if
>>  			// BIOS also does it
>>  			//
>>  			basereg = hwif->channel ? 0x50 : 0x40;
> 
> Please take a close look at the line above and the next three lines:
> 
> for (r = 0; r < 4; ++r) {
> 	pci_read_config_dword (hwif->pci_dev, basereg + (r<<2), &ss->regs[r]);
> }
> 
> It is highly obfuscated but the sc1200_suspend() reads 16 bytes from
> the offset 0x40 (for the primary port) and puts them in the corresponding
> struct sc1200_saved_state_s buffer, then it reads another 16 bytes from the
> offset 0x50 (for the secondary port) and puts it in the another buffer.
> 
> In summary sc1200_suspend() reads 32 continuous bytes from offset 0x40
> and the exactly reverse operation happens in sc1200_resume().
> 
> Given that and the fact that struct sc1200_save_state_s buffers are used
> _only_ by sc1200_{suspend,resume}() we may safely convert the code to use
> one buffer for both ports (the whole PCI device).  We just need to bump
> the size of struct sc1200_saved_state_s (from 4 to 8 double-words) and use
> pci_{get,set}_drvdata() instead of hwif->config_data.  Then we can remove
> looping over interfaces completely from sc1200_{suspend,resume}()! :)

May I assume you'll handle that task?  :)  It sounds like you have a far 
better idea than mine, and my main goal -- fixing bugs and warning -- is 
accomplished anyway with the merging of patch #3.

	Jeff



