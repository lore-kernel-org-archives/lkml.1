Return-Path: <linux-kernel-owner+w=401wt.eu-S1757864AbXK0Edj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757864AbXK0Edj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2007 23:33:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753708AbXK0EdS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Nov 2007 23:33:18 -0500
Received: from andromeda.dapyr.net ([206.212.254.10]:44947 "EHLO
	andromeda.dapyr.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753341AbXK0EdR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2007 23:33:17 -0500
X-Greylist: delayed 522 seconds by postgrey-1.27 at vger.kernel.org; Mon, 26 Nov 2007 23:33:16 EST
From: Konrad Rzeszutek <konrad@darnok.org>
To: Randy Dunlap <randy.dunlap@oracle.com>
Subject: Re: [PATCH] Add iSCSI IBFT Support (v0.3)
Date: Mon, 26 Nov 2007 23:23:36 -0500
User-Agent: KMail/1.9.6
Cc: linux-kernel@vger.kernel.org, pjones@redhat.com, konradr@redhat.com,
       konradr@linux.vnet.ibm.com, greg@kroah.com, hpa@zytor.com,
       lenb@kernel.org, mike.anderson@us.ibm.com, dwm@austin.ibm.com
References: <20071126225642.GA7973@andromeda.dapyr.net> <474B5C68.6080000@oracle.com>
In-Reply-To: <474B5C68.6080000@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200711262323.41906.konrad@darnok.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


.. snip..
> > +#else
> > +static void __init reserve_ibft_region(void) { };
>
> No ending ; above.

Fixed.
>
..snip..
> > +static void __init reserve_ibft_region(void) { };
>
> Ditto.

Fixed.

.. snip..
> > +#include <linux/blkdev.h>
> > +
>
> No blank line here, please.

Why that creeps back in the code I am not sure myself. In your first review 
you mentioned this, I fixed it in my tree, and now it is back!? Either way, 
it is fixed.

>
> > +#include <linux/iscsi_ibft.h>

..snip..

> > +		printk(KERN_INFO  \
>
> Looks like this should use KERN_ERROR or KERN_WARNING?

Yes! Thanks for catching that.
>
> > +			"error, in IBFT structure (%s) expected %d but" \
> > +	return str-buf;
>
> 	preferred form:
> 	return str - buf;

Fixed.
>
..snip..
> > +
> > +	return str-buf;
>
> 	Ditto.
Fixed.

>
..snip..
> > +	return str-buf;
>
> 	Ditto.
Fixed.

..snip..
> > +	return str-buf;
>
> 	Ditto.
Fixed.
..snip..
> > +	int len = 6;
>
> Could you just use ETH_ALEN instead of <len> and 6?
> and #include <linux/if_ether.h>

Yes. That makes much more sense.

>
> Or add a define for IBFT_ALEN (of 6) and use that?

Either one works. The first suggestion is much better.


..snip..
>
> > +
> > +	/* Based on the header index value find the data tuple,
> > +	if possibly. */
>
> 	   if possible. */
>
> or better:
> 	/*
> 	 * Based on the header index value, find the data tuple
> 	 * if possible.
> 	 */

Yes, much more understandable - and now that I read I realized this was
not a proper assumption. One of the data structures (struct ibft_tgt) has a
'nic_assoc' value which makes a N-to-1 mapping to the NIC data structure,
so this will re-work. Thanks for catching a bug that early in the cycle!

..snip..
> > +		   struct carry it for convience. */
>
> 					convenience.
Fixed.

..snip..
> > + * Scan the IBFT table structure for the NIC and Target fields. When
> > + * found add them on the passed in list.
>
> 				passed-in list.

Fixed.

>
> > + */
> > +static int ibft_scan_device(struct ibft_table_header *header,
> > +			    struct list_head *list)
> > +{
> > +
> > +	/* We can have multiple NICs and multiple targets. The index in
> > +	   their header defines their 1-to-1 correlation.

Not true. I will have to re-work this code to do a 1-to-N correlation.
> > +	*/
> > +	for (ptr = &control->nic0_off; ptr <= end; ptr += sizeof(u16)) {
>
> In many searches, <end> would be the first address beyond the end of the
> table, so the loop-terminating condition test would be:
>
> 					ptr < end;

Yes. That is correct. It did actually check the next offset, which fortunately 
had nothing in it.
>
> It looks like that should be the case here also....

To check the offset to make sure it is within the full IBFT data structure? 
Yes, that is a good check - will implement.

>
..snip..
> > +		if (rc) break;
>
> 	break;
> 		on a separate line.
>
> Did you check this patch with scripts/checkpatch.pl ?

Yes. I ran it with check-patch-0.99.pl that I downloaded somewhere from Dave 
Jones web page. I hadn't realized that its home is now in 
scripts/checkpatch.pl - will make sure to use that improved-new version.

>
..snip..
> > +		printk(KERN_INFO "iBFT detected at 0x%lx.\n",
> > +		       (unsigned long)ibft_phys);
>
> Use %p to print pointer values.

This is actually not a pointer yet. It is a true physical address which I 
thought might be useful for troubleshooting purposes.

>
..snip.
> > +	if (!rc)
> > +		return rc;
>
> Can't this always just be
> 	return 0;
> ?

Yes, I was thinking that perhaps a more nicer way was to do 
"goto end;" where the end label is just "return rc;"  But this 
definitely trumps it.

>
> > +
..snip..
> > +
> > +struct ibft_tgt {
> > +	struct ibft_hdr hdr;
> > +	char ip_addr[16];
> > +	u16 port;
> > +	char lun[8];
> > +	u8 chap_type;
> > +	u8 nic_assoc;
> > +	u16 tgt_name_len;
> > +	u16 tgt_name_off;
> > +	u16 chap_name_len;
> > +	u16 chap_name_off;
> > +	u16 chap_secret_len;
> > +	u16 chap_secret_off;
> > +	u16 rev_chap_name_len;
> > +	u16 rev_chap_name_off;
> > +	u16 rev_chap_secret_len;
> > +	u16 rev_chap_secret_off;
> > +} __attribute__((__packed__));
> > +
> > +#if defined(CONFIG_ISCSI_IBFT) || defined(CONFIG_ISCSI_IBFT_MODULE)
>
> Why is this #if line here instead of nearer the top of this header file?

My thought was that if other kernel users might want to include this header 
file they do not have to exposed to the semi-internal data structures of this 
header file. If that is not a concern then I think I can remove the 
conditional altogether.

>
> > +#define IBFT_SIGN "iBFT"
> > +#define IBFT_SIGN_LEN 4
> > +#define IBFT_START 0x80000 /* 512kB */
> > +#define IBFT_END 0x100000 /* 1MB */
> > +#define VGA_MEM 0xA0000 /* VGA buffer */
> > +#define VGA_SIZE 0x20000 /* 132kB */
>
> I'd say that if 0x80000 is 512kB, then 0x20000 is 128kB.

Yes. Did the decimal conversion and forgot about the 1000 != 1024!

>
> Add blank line here, please.
Done.
>

Thanks again for your thorough review. The next version _should_ require no 
comments from you :-)

