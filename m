Return-Path: <linux-kernel-owner+w=401wt.eu-S1754796AbYA1TbO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754796AbYA1TbO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2008 14:31:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758272AbYA1Taz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jan 2008 14:30:55 -0500
Received: from andromeda.dapyr.net ([206.212.254.10]:38314 "EHLO
	andromeda.dapyr.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757971AbYA1Tay (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2008 14:30:54 -0500
X-Greylist: delayed 1458 seconds by postgrey-1.27 at vger.kernel.org; Mon, 28 Jan 2008 14:30:54 EST
From: Konrad Rzeszutek <konrad@darnok.org>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] Add iSCSI iBFT support (v0.4.5)
Date: Mon, 28 Jan 2008 14:04:51 -0500
User-Agent: KMail/1.9.6
Cc: linux-kernel@vger.kernel.org, greg@kroah.com, dwm@enoyolf.org,
       darnok@68k.org, pjones@redhat.com, konradr@redhat.com,
       konradr@linux.vnet.ibm.com, randy.dunlap@oracle.com, hpa@zytor.com,
       lenb@kernel.org, mike.anderson@us.ibm.com, dwm@austin.ibm.com,
       arjan@infradead.org, michaelc@cs.wisc.edu,
       Andy Whitcroft <apw@shadowen.org>
References: <20080125220629.GA25325@andromeda.dapyr.net> <20080126220123.d20dd393.akpm@linux-foundation.org>
In-Reply-To: <20080126220123.d20dd393.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801281404.54155.konrad@darnok.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 27 January 2008 01:01:23 you wrote:
> > On Fri, 25 Jan 2008 18:06:29 -0400 Konrad Rzeszutek <konrad@darnok.org>
> > wrote: Hey Andrew,
> >
> > Please add this patch along with Greg KH's kobject fixes.
>
> erm, OK.  But I don't think I'm the appropriate conduit for iscsi paches.
>
> By what path _does_ iscsi ode get into the tree, anyway?  Mike is listed as
> maintainer...

This is a bit tricky b/c this goes to the drivers/firmware and also depends on 
the kobject changes in Greg KH tree. But I should have included Mike on the 
CC which I keep on forgetting <sigh>.

>
> When adding new sysfs things (especially things as complex as this) please
> fully describe the user-visible interface in the changelog so that we can
> review your interface design.

Done. This repost:
http://lkml.org/lkml/2008/1/28/304

has the details.

>
> Does this code follow the one-value-per-sysfs-file convention?

Yes.
>
> > +#if defined(CONFIG_ISCSI_IBFT_FIND)
> > +static void __init reserve_ibft_region(void)
> > +{
> > +	unsigned int ibft_len;
> > +
> > +	ibft_len = find_ibft();
> > +	if (ibft_len)
> > +		reserve_bootmem((unsigned int)ibft_phys,
> > +				PAGE_ALIGN(ibft_len));
> > +}
> > +#else
> > +static void __init reserve_ibft_region(void) { }
> > +#endif
>
> Usually we'd make the CONFIG_ISCSI_IBFT_FIND=n version of this function
> static inline in a header.  As it stands this code will add a pointless
> empty function to the vmlinux image.

Fixed. The function now is in include/linux/iscsi_ibft.h

>
> >  int __initdata user_defined_memmap = 0;
>
> checkpatch should have told you that this "= 0" shouldn't be there.  But it
> doesn't.

Uhh, I didn't add that.

>
> > +	struct kobject *kobj;
> > +	int type; /* The enum of the type. This can be any value off:
> > +		ibft_eth_properties_enum, ibft_tgt_properties_enum,
> > +		or ibft_initiator_properties_enum. */
> > +	struct list_head node;
> > +};
> > +
> > +static LIST_HEAD(ibft_attr_list);
> > +static LIST_HEAD(ibft_kobject_list);
>
> A brief search for the locking which protects these lists was unsuccessful.
> What's up?

The data structure does not change when the machine has booted up. The iBFT is 
a read-only structure and there are no known mechanism to write to it via the 
iBFT structure (or even BIOS up-calls). You have to use custom-vendor 
applications to flash the BIOS with the new iBFT structure. Hence no need for 
locking at this stage - when the specs becomes more advance I will add them 
if they are required.

>
> > +/*
> > + * Helper functions to parse data properly.
> > + */
> > +static ssize_t sprintf_ipaddr(char *buf, u8 *ip)
> > +{
> > +	if (ip[0] == 0 && ip[1] == 0 && ip[2] == 0 && ip[3] == 0 &&
> > +	    ip[4] == 0 && ip[5] == 0 && ip[6] == 0 && ip[7] == 0 &&
> > +	    ip[8] == 0 && ip[9] == 0 && ip[10] == 0xff && ip[11] == 0xff) {
> > +		/*
> > +		 * IPV4
> > +		 */
> > +		return sprintf(buf, "%d.%d.%d.%d\n", ip[12],
> > +			       ip[13], ip[14], ip[15]);
> > +	} else
> > +		return 0;
> > +}
>
> I'm seeing an awful lot of sprintf()s in here which look like they should
> be snprintf().  By what means is this code bulletproof against overflows?

There is no reading of data from the user-land. All of it is just outputing to 
the /sysfs entries from reading the data in the iBFT structure which the BIOS 
created.
>
> > +static ssize_t sprintf_string(char *str, int len, char *buf)
> > +{
> > +	return sprintf(str, "%.*s\n", len, buf);
> > +}
> > +
> > +/*
> > + * Helper function to verify the IBFT header.
> > + */
> > +static int ibft_verify_hdr(char *t, struct ibft_hdr *hdr, int id, int
> > length) +{
> > +#define IBFT_VERIFY_HDR_FIELD(val, name) \
> > +	if (hdr->val != val) { \
> > +		printk(KERN_ERR \
> > +		       "iBFT error: In structure %s field %s expected %d but" \
> > +		       " found %d!\n", \
> > +		       t, name, val, hdr->val); \
> > +		return -ENODEV; \
> > +	}
> > +	IBFT_VERIFY_HDR_FIELD(id, "id");
> > +	IBFT_VERIFY_HDR_FIELD(length, "length");
> > +	return 0;
> > +}
>
> I'm not sure that two usages really justifies IBFT_VERIFY_HDR_FIELD's
> existence.  If you're really attched to it then I'd suggest that it be
> undefed immediately after having been read, for readability reasons.

Done. Took out the #define.

>
> > +static void ibft_release(struct kobject *kobj)
> > +{
> > +	struct ibft_kobject *ibft =
> > +		container_of(kobj, struct ibft_kobject, kobj);
> > +	kfree(ibft);
> > +}
> >
> > ...
> >
> > +	for (pos = (u8 *)hdr; pos < (u8 *)hdr + len; pos ++)
>
> checkpatch should have caught the " ++" but didn't.  I think it used to.
> It seems to be going backwards?

Fixed.
> > ...
> >
> > +
> > +	/* kobject fief. We will let the reference counter do the job
> > +	 of deleting its name if we fail here. */
>
> what's a fief?

FIEF, or FEUD. In its origin, a fief was a district of country allotted to 
one of the chiefs who invaded the Roman empire, as a stipend or reward.
>
> > +/*
> > + * Physical location of iSCSI Boot Format Table.
> > + */
> > +void *ibft_phys;
> > +EXPORT_SYMBOL(ibft_phys);
> > +
> > +#define IBFT_SIGN "iBFT"
> > +#define IBFT_SIGN_LEN 4
> > +#define IBFT_START 0x80000 /* 512kB */
> > +#define IBFT_END 0x100000 /* 1MB */
> > +#define VGA_MEM 0xA0000 /* VGA buffer */
> > +#define VGA_SIZE 0x20000 /* 128kB */
> > +
> > +
> > +/*
> > + * Routine used to find the iSCSI Boot Format Table. the physical
> > + * location is set in the ibft_phys variable. The return value is
> > + * the size of IBFT.
> > + */
> > +ssize_t find_ibft(void)
> > +{
> > +	unsigned long pos;
> > +
> > +	for (pos = IBFT_START; pos < IBFT_END; pos += 16) {
> > +		void *virt;
> > +		/* The table can't be inside the VGA BIOS reserved space,
> > +		 * so skip that area */
> > +		if (pos == VGA_MEM)
> > +			pos += VGA_SIZE;
> > +		virt = phys_to_virt(pos);
> > +		if (memcmp(virt, IBFT_SIGN, IBFT_SIGN_LEN) == 0) {
> > +			unsigned long *addr =
> > +			    (unsigned long *)phys_to_virt(pos + 4);
> > +			unsigned int len = *addr;
> > +			/* if the length of the table extends past 1M,
> > +			 * the table cannot be valid. */
> > +			if (pos + len <= (IBFT_END-1)) {
> > +				ibft_phys = (void *)pos;
> > +				return len;
> > +			}
> > +		}
> > +	}
> > +	return 0;
> > +}
> > +EXPORT_SYMBOL(find_ibft);
>
> Is this x86-specific?  Are suitable Kconfig dependencies in place?

Originally I had it to be x86-specific but was told that I should make it all 
platforms since the IBFT is platform independent. Somebody can very well 
insert a NIC with IBFT on a IA64 machine or PPC.

> > +#define ISCSI_IBFT_H
> > +
> > +#if defined(CONFIG_ISCSI_IBFT_FIND)
>
> We'd more usually use #ifdef here.  Whatever.

Fixed.

>
> > +/*
> > + * Physical location of iSCSI Boot Format Table.
> > + */
> > +extern void *ibft_phys;
> > +
> > +/*
> > + * Routine used to find the iSCSI Boot Format Table. The physical
> > + * location is set in the ibft_phys variable. The return value is the
> > + * size of IBFT.
> > + */
> > +extern ssize_t find_ibft(void);
> > +
> > +#endif
>
> Often we don't bother putting declarations like this inside the ifdef.
> Upside: cleaner code.  Downside: error-detection happens at link-time
> rather tha compile-time.

Ok. Fixed it.
