Return-Path: <linux-kernel-owner+w=401wt.eu-S1756781AbYLDNOy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756781AbYLDNOy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2008 08:14:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754501AbYLDNOp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Dec 2008 08:14:45 -0500
Received: from fg-out-1718.google.com ([72.14.220.158]:26608 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754096AbYLDNOn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2008 08:14:43 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:reply-to:to:subject:cc:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:references;
        b=a95NMm3FliiHAhEliwRV08VezIGJAXjx73h//+COQLfeAjMRxXDBhSu5xlYDCe4W2b
         mv9KxOKEfX+ARlOkDDUDJA7RdCTJQCqazyDsHy6JthcLuLIC66ks7SxF4PXSYhVKcJpi
         HF/EyB5fq5Vx0RGNvoHKXV5Xdz5jIDGyq/QgU=
Message-ID: <cfd18e0f0812040514r45f8f74dh63be0d68567b8e60@mail.gmail.com>
Date: Thu, 4 Dec 2008 08:14:41 -0500
From: "Michael Kerrisk" <mtk.manpages@googlemail.com>
Reply-To: mtk.manpages@gmail.com
To: "Edward Estabrook" <edward.estabrook.lkml@gmail.com>
Subject: Re: [PATCH 1/1] Userspace I/O (UIO): Documentatin for userspace DMA support
Cc: linux-kernel@vger.kernel.org, linux-api@vger.kernel.org,
       "Greg KH" <gregkh@suse.de>, hjk@linutronix.de,
       edward_estabrook@agilent.com
In-Reply-To: <208aa0f00812032053w5efb99dbk94511b0f8c1f0925@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <208aa0f00812032053w5efb99dbk94511b0f8c1f0925@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Edward,

A few small comments below

On Wed, Dec 3, 2008 at 11:53 PM, Edward Estabrook
<edward.estabrook.lkml@gmail.com> wrote:
> From: Edward Estabrook <Edward_Estabrook@agilent.com>
>
> Here is a patch updating the Userspace IO documentation to
> detail support to dynamically allocate and use coherent DMA
> from userspace.  This patch applies against 2.6.28-rc6.
>
> The gist of this implementation is to overload uio's mmap

Sometimes you write "uio", sometimes "UIO".  Use just one?

> functionality to allocate
> and map a new DMA region on demand.  The bus-specific DMA address as returned by
> dma_alloc_coherent() is made available to userspace in the 1st long
> word

Perhaps use a clearer term than "long word"?  Maybe '8 bytes'?

> of the newly
> created region (as well as through the conventional 'addr' file in sysfs).
>
> The kernel-api change is that passing an offset value of 0xFFFFF000UL to a uio

s/api/API/

> device's mmap() operation will dynamically allocate a DMA region.  This cannot
> break existing code as the previous UIO code only allowed a maximum of 5
> mappings.
>
> To allocate a DMA region you use the following:
> /* Pass this magic number to mmap as offset to
>  * dynamically allocate a chunk of memory */
> #define DMA_MEM_ALLOCATE_MMAP_OFFSET 0xFFFFF000UL
>
> void* memory = mmap (NULL, size, PROT_READ | PROT_WRITE , MAP_SHARED,
>                     fd, DMA_MEM_ALLOCATE_MMAP_OFFSET);
> u_int64_t *addr = *(u_int64_t *) memory;
>
> where 'size' is the size in bytes of the region you want and fd is the

s/fd/'fd'/  (consistent with 'size')

> opened /dev/uioN file.
>
> Allocation occurs in page sized pieces by design to ensure that

s/page sized pieces/page-sized pieces/

> buffers are page-aligned.
>
> Memory is released when the uio_unregister_device() is called.


Cheers,

Michael

> Signed-off-by: Edward Estabrook <Edward_Estabrook@agilent.com>
> ---
> --- linux-2.6.28-rc6/Documentation/DocBook/uio-howto.tmpl.orig  2008-12-03
> 12:03:43.000000000 -0800
> +++ linux-2.6.28-rc6/Documentation/DocBook/uio-howto.tmpl       2008-12-03
> 13:11:53.000000000 -0800
> @@ -42,6 +42,12 @@ GPL version 2.
>
>  <revhistory>
>        <revision>
> +       <revnumber>0.6</revnumber>
> +       <date>2008-12-03</date>
> +       <authorinitials>ee</authorinitials>
> +       <revremark>Added description of DMA control.</revremark>
> +       </revision>
> +       <revision>
>        <revnumber>0.5</revnumber>
>        <date>2008-05-22</date>
>        <authorinitials>hjk</authorinitials>
> @@ -284,11 +290,17 @@ interested in translating it, please ema
>        require access to more than one PCI memory region in a driver.
>  </para>
>  <para>
> +       Each UIO device can also dynamically allocate coherent DMA
> +       memory regions and map these to userspace.  Once created they
> +       can be mapped like any other UIO memory region.
> +</para>
> +<para>
>        Each mapping has its own directory in sysfs, the first mapping
>        appears as <filename>/sys/class/uio/uioX/maps/map0/</filename>.
>        Subsequent mappings create directories <filename>map1/</filename>,
> -       <filename>map2/</filename>, and so on. These directories will only
> -       appear if the size of the mapping is not 0.
> +       <filename>map2/</filename>, and so on. These directories will
> +       appear even if the size of the mapping is 0 to accommodate dynamically
> +       created DMA mappings.
>  </para>
>  <para>
>        Each <filename>mapX/</filename> directory contains two read-only files
> @@ -318,6 +330,24 @@ interested in translating it, please ema
>  offset = N * getpagesize();
>  </programlisting>
>
> +<para>
> +       From userspace a DMA region may be dynamically allocated and mapped
> +       via the <function>mmap()</function> call by specifying the size of the
> +       region in bytes in the <varname>length</varname> parameter and setting
> +       <varname>offset = 0xFFFFF000</varname>.
> +</para>
> +<para>
> +       The bus-specific DMA address as required to configure hardware DMA
> +       registers will be stored in the first long word of the resulting mapped
> +       region.
> +</para>
> +<programlisting format="linespecific">
> +#define DMA_MEM_ALLOCATE_MMAP_OFFSET 0xFFFFF000UL
> +void* memory = mmap (NULL, size, PROT_READ | PROT_WRITE , MAP_SHARED,
> +                    fd, DMA_MEM_ALLOCATE_MMAP_OFFSET);
> +u_int64_t *addr = *(u_int64_t *) memory;
> +</programlisting>
> +
>  </sect1>
>  </chapter>
>
> @@ -572,6 +602,50 @@ to set up sysfs files for this mapping.
>        </para>
>  </sect1>
>
> +<sect1 id="dma_region_mmap">
> +<title>Allocating DMA region with mmap()</title>
> +       <para>
> +       To allocate and map a DMA memory region you use
> +       use <function>mmap()</function>.  You may create as
> +       many regions as system resources allow by repeated use of
> +       <function>mmap()</function>.
> +       </para>
> +       <para>
> +       Specify the size of the desired region, in bytes, in the
> +       <varname>length</varname> parameter and set
> +       <varname>offset = 0xFFFFF000</varname>.  The region size will
> +       be rounded up to a multiple of page size to ensure proper
> +       alignment.
> +       </para>
> +       <para>
> +       The bus-specific DMA address is stored in the first long word of the
> +       resulting mapped region.  The newly assigned memory index N is
> +       returned in the second long word of the resulting mapped region.  This
> +       index is only required if the userspace driver needs to unmap and
> +       then later remap the DMA region as the single call to
> +       <function>mmap()</function> is sufficient to both allocate and map the
> +       region.
> +       </para>
> +       <para>
> +       Since every memory mapping has its own directory in sysfs
> +       <filename>/sys/class/uio/uioX/maps/mapN/</filename> will be created
> +       where N is the dynamically generated index of the mapping just
> +       allocated.
> +       </para>
> +       <para>
> +       Dynamically allocated DMA regions remain available for use
> +       until <function>uio_unregister_device()</function> is called, at
> +       which point the memory is released.
> +       </para>
> +<programlisting format="linespecific">
> +       #define DMA_MEM_ALLOCATE_MMAP_OFFSET 0xFFFFF000UL
> +       void* memory = mmap (NULL, size, PROT_READ | PROT_WRITE , MAP_SHARED,
> +                            fd, DMA_MEM_ALLOCATE_MMAP_OFFSET);
> +       u_int64_t *addr = *(u_int64_t *) memory;
> +</programlisting>
> +
> +</sect1>
> +
>  <sect1 id="wait_for_interrupts">
>  <title>Waiting for interrupts</title>
>        <para>
> @@ -583,7 +657,7 @@ to set up sysfs files for this mapping.
>        attention because an error occured.
>        </para>
>        <para>
> -       <filename>/dev/uioX</filename> is a read-only file. A
> +       <filename>/dev/uioX</filename> is a read-write file. A
>        <function>read()</function> will always block until an
>        interrupt occurs. There is only one legal value for the
>        <varname>count</varname> parameter of
> --
> To unsubscribe from this list: send the line "unsubscribe linux-api" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>



-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
git://git.kernel.org/pub/scm/docs/man-pages/man-pages.git
man-pages online: http://www.kernel.org/doc/man-pages/online_pages.html
Found a bug? http://www.kernel.org/doc/man-pages/reporting_bugs.html
