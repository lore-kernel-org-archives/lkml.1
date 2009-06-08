Return-Path: <linux-kernel-owner+w=401wt.eu-S1754015AbZFHJtB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754015AbZFHJtB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jun 2009 05:49:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751308AbZFHJsx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Jun 2009 05:48:53 -0400
Received: from hqemgate04.nvidia.com ([216.228.112.152]:12707 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751003AbZFHJsw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jun 2009 05:48:52 -0400
X-Greylist: delayed 359 seconds by postgrey-1.27 at vger.kernel.org; Mon, 08 Jun 2009 05:48:52 EDT
X-PGP-Universal: processed;
	by hqnvupgp04.nvidia.com on Mon, 08 Jun 2009 02:41:50 -0700
MIME-Version: 1.0
X-MimeOLE: Produced By Microsoft Exchange V6.5
Subject: RE: [Bug 13484] System report Int 6 error if E820 table reserve the memory above 4G
Date: Mon, 8 Jun 2009 17:41:38 +0800
Message-ID: <15F501D1A78BD343BE8F4D8DB854566B4283361E@hkemmail01.nvidia.com>
In-Reply-To: <4A2CB48C.4080707@kernel.org>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [Bug 13484] System report Int 6 error if E820 table reserve the memory above 4G
Thread-Index: AcnoBZn42v51QYNDRpaxj/ghSnDXPAAF6vJQ
References: <bug-13484-13546@http.bugzilla.kernel.org/> <200906080543.n585hQYj017771@demeter.kernel.org> <4A2CB48C.4080707@kernel.org>
From: "Peer Chen" <pchen@nvidia.com>
To: "Yinghai Lu" <yinghai@kernel.org>, <bugzilla-daemon@bugzilla.kernel.org>,
       "Ingo Molnar" <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       "Thomas Gleixner" <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>, <linux-kernel@vger.kernel.org>,
       "Bernhard Walle" <bwalle@suse.de>
X-OriginalArrivalTime: 08 Jun 2009 09:41:48.0564 (UTC) FILETIME=[580BE540:01C9E81D]
Content-class: urn:content-classes:message
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yinghai,

The patch works, thanks.

BRs
Peer Chen
> -----Original Message-----
> From: Yinghai Lu [mailto:yinghai@kernel.org]
> Sent: Monday, June 08, 2009 2:50 PM
> To: bugzilla-daemon@bugzilla.kernel.org; Ingo Molnar; H. Peter Anvin;
Thomas Gleixner; H. Peter Anvin; linux-kernel@vger.kernel.org;
> Peer Chen; Bernhard Walle
> Subject: Re: [Bug 13484] System report Int 6 error if E820 table
reserve the memory above 4G
> 
> bugzilla-daemon@bugzilla.kernel.org wrote:
> > http://bugzilla.kernel.org/show_bug.cgi?id=13484
> >
> >
> >
> >
> >
> > --- Comment #3 from Peer Chen <pchen@nvidia.com>  2009-06-08
05:43:25 ---
> > I'm using 64bit CPU, Intel P8400.
> >
> > Yes, if set CONFIG_PHYS_ADDR_T_64BIT, the problem goes away.
> >
> 
> please check
> 
> ---
>  drivers/firmware/memmap.c    |   12 +++++-------
>  include/linux/firmware-map.h |   12 ++++--------
>  2 files changed, 9 insertions(+), 15 deletions(-)
> 
> Index: linux-2.6/drivers/firmware/memmap.c
> ===================================================================
> --- linux-2.6.orig/drivers/firmware/memmap.c
> +++ linux-2.6/drivers/firmware/memmap.c
> @@ -31,8 +31,8 @@
>   * information is necessary as for the resource tree.
>   */
>  struct firmware_map_entry {
> -	resource_size_t		start;	/* start of the memory range */
> -	resource_size_t		end;	/* end of the memory range
(incl.) */
> +	u64			start;	/* start of the memory range */
> +	u64			end;	/* end of the memory range
(incl.) */
>  	const char		*type;	/* type of the memory range */
>  	struct list_head	list;	/* entry for the linked list */
>  	struct kobject		kobj;   /* kobject for each entry */
> @@ -101,7 +101,7 @@ static LIST_HEAD(map_entries);
>   * Common implementation of firmware_map_add() and
firmware_map_add_early()
>   * which expects a pre-allocated struct firmware_map_entry.
>   **/
> -static int firmware_map_add_entry(resource_size_t start,
resource_size_t end,
> +static int firmware_map_add_entry(u64 start, u64 end,
>  				  const char *type,
>  				  struct firmware_map_entry *entry)
>  {
> @@ -132,8 +132,7 @@ static int firmware_map_add_entry(resour
>   *
>   * Returns 0 on success, or -ENOMEM if no memory could be allocated.
>   **/
> -int firmware_map_add(resource_size_t start, resource_size_t end,
> -		     const char *type)
> +int firmware_map_add(u64 start, u64 end, const char *type)
>  {
>  	struct firmware_map_entry *entry;
> 
> @@ -157,8 +156,7 @@ int firmware_map_add(resource_size_t sta
>   *
>   * Returns 0 on success, or -ENOMEM if no memory could be allocated.
>   **/
> -int __init firmware_map_add_early(resource_size_t start,
resource_size_t end,
> -				  const char *type)
> +int __init firmware_map_add_early(u64 start, u64 end, const char
*type)
>  {
>  	struct firmware_map_entry *entry;
> 
> Index: linux-2.6/include/linux/firmware-map.h
> ===================================================================
> --- linux-2.6.orig/include/linux/firmware-map.h
> +++ linux-2.6/include/linux/firmware-map.h
> @@ -24,21 +24,17 @@
>   */
>  #ifdef CONFIG_FIRMWARE_MEMMAP
> 
> -int firmware_map_add(resource_size_t start, resource_size_t end,
> -		     const char *type);
> -int firmware_map_add_early(resource_size_t start, resource_size_t
end,
> -			   const char *type);
> +int firmware_map_add(u64 start, u64 end, const char *type);
> +int firmware_map_add_early(u64 start, u64 end, const char *type);
> 
>  #else /* CONFIG_FIRMWARE_MEMMAP */
> 
> -static inline int firmware_map_add(resource_size_t start,
resource_size_t end,
> -				   const char *type)
> +static inline int firmware_map_add(u64 start, u64 end, const char
*type)
>  {
>  	return 0;
>  }
> 
> -static inline int firmware_map_add_early(resource_size_t start,
> -					 resource_size_t end, const char
*type)
> +static inline int firmware_map_add_early(u64 start, u64 end, const
char *type)
>  {
>  	return 0;
>  }
-----------------------------------------------------------------------------------
This email message is for the sole use of the intended recipient(s) and may contain
confidential information.  Any unauthorized review, use, disclosure or distribution
is prohibited.  If you are not the intended recipient, please contact the sender by
reply email and destroy all copies of the original message.
-----------------------------------------------------------------------------------
