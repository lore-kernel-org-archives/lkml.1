Return-Path: <linux-kernel-owner+w=401wt.eu-S932198AbZHJQ3W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932198AbZHJQ3W (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Aug 2009 12:29:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932109AbZHJQ3V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Aug 2009 12:29:21 -0400
Received: from exprod5og110.obsmtp.com ([64.18.0.20]:42286 "EHLO
	exprod5og110.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932173AbZHJQ3S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Aug 2009 12:29:18 -0400
Message-ID: <4A804B0B.5020809@gefanuc.com>
Date: Mon, 10 Aug 2009 17:30:03 +0100
From: Martyn Welch <martyn.welch@gefanuc.com>
User-Agent: Thunderbird 2.0.0.22 (X11/20090608)
MIME-Version: 1.0
To: "Emilio G. Cota" <cota@braap.org>
CC: Greg K-H <gregkh@suse.de>, linux-kernel@vger.kernel.org,
       devel@driverdev.osuosl.org, Sebastien Dugue <sebastien.dugue@bull.net>
Subject: Re: [patch 2/5] Staging: vme: add VME userspace driver
References: <20090803205657.964064732@mini.kroah.org> <20090803210116.GC28430@kroah.com> <20090808232259.GA29303@braap.org> <20090809121715.GA3884@braap.org> <4A801D04.6050102@gefanuc.com> <20090810152606.GA23319@braap.org>
In-Reply-To: <20090810152606.GA23319@braap.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Emilio G. Cota wrote:
> Martyn Welch wrote:
>   
>>>> Instead of using that we implemented a heretic IOCTL-based
>>>> interface for user-space; at least with it you could create a
>>>>         
> [ snip ]
>   
>>>> #define VME_IOCTL_START_DMA             _IOWR('V', 10, struct vme_dma)
>>>>
>>>>         
>> I am moving the interface in that direction, I remain unconvinced about  
>> the contents of your vme_mapping structure, it's too tsi-148 specific.
>>     
>
> Could you please point out why is too tsi148-specific?
>
> The point here is that the driver should know *nothing* about
> windows, etc. What it should just know is:
> - I want a mapping of a certain size to VME address X
>   

I'm not convinced. Given that each bridge provides a limited number of 
windows (some more than others), we are limited to how large a window we 
can produce (we need to map them somewhere) and the potential 
combinations are so great (independant 16, 32, 40, 64 and CR/CSR address 
spaces, not to mention access modes) it is important to assign the 
windows to a driver, so that it may move them as it sees fit. For 
example, supporting 10 devices (as you have mentioned earier) with a 
single driver could potentially require a single window that it knows it 
has exclusive use of to position over each devices register as required 
without either having to provide a large window (unfeasibly large on 
most/all platforms if they are scattered across the 64-bit address 
space) or needing more windows than are available on any of the bridges 
I have seen (8 being the maximum).

> The struct provides exactly this.
>   
Ah - vme_dma does to some degree. I was talking about vme_mapping for 
configuring vme windows, from your vmebus.h:

115 
<http://repo.or.cz/w/tsi148vmebridge.git?a=blob;f=driver/vmebus.h;h=6f25a7715a973ae07a6d1f71bdb15d638a56e7aa;hb=HEAD#l115> 
 * This data structure is used for describing both a hardware window
116 
<http://repo.or.cz/w/tsi148vmebridge.git?a=blob;f=driver/vmebus.h;h=6f25a7715a973ae07a6d1f71bdb15d638a56e7aa;hb=HEAD#l116> 
 * and a logical mapping on top of a hardware window. Therefore some of
117 
<http://repo.or.cz/w/tsi148vmebridge.git?a=blob;f=driver/vmebus.h;h=6f25a7715a973ae07a6d1f71bdb15d638a56e7aa;hb=HEAD#l117> 
 * the fields are only relevant to one of those two entities.
118 
<http://repo.or.cz/w/tsi148vmebridge.git?a=blob;f=driver/vmebus.h;h=6f25a7715a973ae07a6d1f71bdb15d638a56e7aa;hb=HEAD#l118> 
 */
119 
<http://repo.or.cz/w/tsi148vmebridge.git?a=blob;f=driver/vmebus.h;h=6f25a7715a973ae07a6d1f71bdb15d638a56e7aa;hb=HEAD#l119> 
struct vme_mapping {
120 
<http://repo.or.cz/w/tsi148vmebridge.git?a=blob;f=driver/vmebus.h;h=6f25a7715a973ae07a6d1f71bdb15d638a56e7aa;hb=HEAD#l120> 
        int     window_num;
121 
<http://repo.or.cz/w/tsi148vmebridge.git?a=blob;f=driver/vmebus.h;h=6f25a7715a973ae07a6d1f71bdb15d638a56e7aa;hb=HEAD#l121> 

122 
<http://repo.or.cz/w/tsi148vmebridge.git?a=blob;f=driver/vmebus.h;h=6f25a7715a973ae07a6d1f71bdb15d638a56e7aa;hb=HEAD#l122> 
        /* Reserved for kernel use */
123 
<http://repo.or.cz/w/tsi148vmebridge.git?a=blob;f=driver/vmebus.h;h=6f25a7715a973ae07a6d1f71bdb15d638a56e7aa;hb=HEAD#l123> 
        void    *kernel_va;
124 
<http://repo.or.cz/w/tsi148vmebridge.git?a=blob;f=driver/vmebus.h;h=6f25a7715a973ae07a6d1f71bdb15d638a56e7aa;hb=HEAD#l124>
125 
<http://repo.or.cz/w/tsi148vmebridge.git?a=blob;f=driver/vmebus.h;h=6f25a7715a973ae07a6d1f71bdb15d638a56e7aa;hb=HEAD#l125> 
        /* Reserved for userspace */
126 
<http://repo.or.cz/w/tsi148vmebridge.git?a=blob;f=driver/vmebus.h;h=6f25a7715a973ae07a6d1f71bdb15d638a56e7aa;hb=HEAD#l126> 
        void    *user_va;
127 
<http://repo.or.cz/w/tsi148vmebridge.git?a=blob;f=driver/vmebus.h;h=6f25a7715a973ae07a6d1f71bdb15d638a56e7aa;hb=HEAD#l127> 
        int     fd;
128 
<http://repo.or.cz/w/tsi148vmebridge.git?a=blob;f=driver/vmebus.h;h=6f25a7715a973ae07a6d1f71bdb15d638a56e7aa;hb=HEAD#l128> 

129 
<http://repo.or.cz/w/tsi148vmebridge.git?a=blob;f=driver/vmebus.h;h=6f25a7715a973ae07a6d1f71bdb15d638a56e7aa;hb=HEAD#l129> 
        /* Window settings */
130 
<http://repo.or.cz/w/tsi148vmebridge.git?a=blob;f=driver/vmebus.h;h=6f25a7715a973ae07a6d1f71bdb15d638a56e7aa;hb=HEAD#l130> 
        int                             window_enabled;
131 
<http://repo.or.cz/w/tsi148vmebridge.git?a=blob;f=driver/vmebus.h;h=6f25a7715a973ae07a6d1f71bdb15d638a56e7aa;hb=HEAD#l131> 
        enum vme_data_width             data_width;
132 
<http://repo.or.cz/w/tsi148vmebridge.git?a=blob;f=driver/vmebus.h;h=6f25a7715a973ae07a6d1f71bdb15d638a56e7aa;hb=HEAD#l132> 
        enum vme_address_modifier       am;
133 
<http://repo.or.cz/w/tsi148vmebridge.git?a=blob;f=driver/vmebus.h;h=6f25a7715a973ae07a6d1f71bdb15d638a56e7aa;hb=HEAD#l133> 
        int                             read_prefetch_enabled;
134 
<http://repo.or.cz/w/tsi148vmebridge.git?a=blob;f=driver/vmebus.h;h=6f25a7715a973ae07a6d1f71bdb15d638a56e7aa;hb=HEAD#l134> 
        enum vme_read_prefetch_size     read_prefetch_size;

Tsi-148 specific.

135 
<http://repo.or.cz/w/tsi148vmebridge.git?a=blob;f=driver/vmebus.h;h=6f25a7715a973ae07a6d1f71bdb15d638a56e7aa;hb=HEAD#l135> 
        enum vme_2esst_mode             v2esst_mode;
136 
<http://repo.or.cz/w/tsi148vmebridge.git?a=blob;f=driver/vmebus.h;h=6f25a7715a973ae07a6d1f71bdb15d638a56e7aa;hb=HEAD#l136> 
        int                             bcast_select;
137 
<http://repo.or.cz/w/tsi148vmebridge.git?a=blob;f=driver/vmebus.h;h=6f25a7715a973ae07a6d1f71bdb15d638a56e7aa;hb=HEAD#l137> 
        unsigned int                    pci_addru;
138 
<http://repo.or.cz/w/tsi148vmebridge.git?a=blob;f=driver/vmebus.h;h=6f25a7715a973ae07a6d1f71bdb15d638a56e7aa;hb=HEAD#l138> 
        unsigned int                    pci_addrl;

Why are these split, why not a single unsigned long long?

139 
<http://repo.or.cz/w/tsi148vmebridge.git?a=blob;f=driver/vmebus.h;h=6f25a7715a973ae07a6d1f71bdb15d638a56e7aa;hb=HEAD#l139> 
        unsigned int                    sizeu;
140 
<http://repo.or.cz/w/tsi148vmebridge.git?a=blob;f=driver/vmebus.h;h=6f25a7715a973ae07a6d1f71bdb15d638a56e7aa;hb=HEAD#l140> 
        unsigned int                    sizel;

Ditto.

141 
<http://repo.or.cz/w/tsi148vmebridge.git?a=blob;f=driver/vmebus.h;h=6f25a7715a973ae07a6d1f71bdb15d638a56e7aa;hb=HEAD#l141> 
        unsigned int                    vme_addru;
142 
<http://repo.or.cz/w/tsi148vmebridge.git?a=blob;f=driver/vmebus.h;h=6f25a7715a973ae07a6d1f71bdb15d638a56e7aa;hb=HEAD#l142> 
        unsigned int                    vme_addrl;

Ditto.

143 
<http://repo.or.cz/w/tsi148vmebridge.git?a=blob;f=driver/vmebus.h;h=6f25a7715a973ae07a6d1f71bdb15d638a56e7aa;hb=HEAD#l143> 
};

In addition your enum vme_address_modifier would need extending when 
specifying slave windows, the tsi-148 can support windows with USER and 
SUP access, as well as DATA and PRG. Why throw access privileges and 
address spaces together like that? The VME spec also specifies 4 User 
definable  address spaces...

I'm still not convinced by all these structures - you've defined tonnes 
of them, I don't feel that it aids readability and maintainability at all.

> Also, could you please send me (off-list) documentation of the
> Universe bridge? It'd be useful for the work on the generic layer.
>
>   
It's all over the web :-) We've had it for years and I'm not sure under 
what terms we originally got it, so I'm afraid I've got to assume we're 
still bound under some NDA, sorry. Searching google for "Universe II 
Manual" much get you what you want though...

Martyn

> E.
>   



-- 
Martyn Welch MEng MPhil MIET (Principal Software Engineer)   T:+44(0)1327322748
GE Fanuc Intelligent Platforms Ltd,        |Registered in England and Wales
Tove Valley Business Park, Towcester,      |(3828642) at 100 Barbirolli Square,
Northants, NN12 6PF, UK T:+44(0)1327359444 |Manchester,M2 3AB  VAT:GB 927559189
