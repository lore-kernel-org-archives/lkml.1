Return-Path: <linux-kernel-owner+w=401wt.eu-S1759080AbYBMEjR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759080AbYBMEjR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 23:39:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753188AbYBMEjH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 23:39:07 -0500
Received: from smtp102.sbc.mail.mud.yahoo.com ([68.142.198.201]:28115 "HELO
	smtp102.sbc.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752407AbYBMEjF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 23:39:05 -0500
X-YMail-OSG: g_mT1oYVM1kIo2X8qzuvmgZ98Z8Fo_492iwxLyU1CHIwA.uNtey5kv4RmSrgm31IZIVF1cyKBu7.f63vSpOSn7xQZ4kmqUKrZoLm0aYWwCIbzE9LJ9o-
X-Yahoo-Newman-Property: ymail-3
Subject: Re: struct page vs page_link
From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
To: Mark Tuttle <marklinux@tuttlelabs.com>,
       Bart Van Assche <bart.vanassche@gmail.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       Mike Christie <michaelc@cs.wisc.edu>, Ming Zhang <mingz@ele.uri.edu>,
       Andrew Morton <akpm@osdl.org>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <9803672c0802101126u4dd171dai48ea3d21fa84091e@mail.gmail.com>
References: <9803672c0802082228h2c3f543ak8c631fcd3a8077ea@mail.gmail.com>
	 <1202558777.1805.220.camel@haakon2.linux-iscsi.org>
	 <9803672c0802101126u4dd171dai48ea3d21fa84091e@mail.gmail.com>
Content-Type: text/plain
Date: Tue, 12 Feb 2008 20:20:46 -0800
Message-Id: <1202876446.19945.18.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mark,

After Bark posted an BUG() when CONFIG_DEBUG_SG was used with
LIO-Target, I add the proper usage of sg_table_init() and sg_mark_end()
in the LIO-Target SE.  Please update your case (if you are not doing it
already).  Here are my new changes for those who are still updating
drivers to use the new include/linux/scatterlist.h API.

--nab 

Index: include/iscsi_linux_defs.h
===================================================================
--- include/iscsi_linux_defs.h  (revision 214)
+++ include/iscsi_linux_defs.h  (revision 215)
@@ -49,11 +49,14 @@
  * code, and use inline functions for legacy operation. 
  */
 #if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,24)
+# define SET_SG_TABLE(sg, cnt)         sg_init_table((struct scatterlist *)&sg[0], cnt);       \
+                                               sg_mark_end((struct scatterlist *)&sg[cnt - 1]);
 # define GET_ADDR_SG(sg)               sg_virt(sg)
 # define GET_PAGE_SG(sg)               sg_page(sg)
 # define SET_PAGE_SG(sg, page)         sg_assign_page(sg, page)
 #else
 #include <linux/scatterlist.h>
+#define SET_SG_TABLE(sg, cnt)  
 static inline void *GET_ADDR_SG(struct scatterlist *sg)
 {
        return(page_address(sg->page) + sg->offset);

As you can see, the pre 2.6.24 case expands to a nop.

In my case with LIO-Target and generating SC arrays going to the default
path (which is common for PSCSI, IBLOCK, FILE, and RAMDISK_MCP) where
se_mem_t list head struct page is mapped to struct page-link in the
contigious struct scatterlist arrays.

In the iscsi_target_transport.c:transport_calc_sg_num() and scatterlist
allocation for RAMDISK_DR and RAMDISK_MCP, I added the usage of
SET_SG_TABLE right after the array of struct scatterlist right after the
struct scatterlist array has been allocated and memset.

Index: target/iscsi_target_rd.c
===================================================================
--- target/iscsi_target_rd.c    (revision 215)
+++ target/iscsi_target_rd.c    (revision 217)
@@ -209,6 +209,8 @@
                }
                memset(sg, 0, sg_per_table * sizeof(struct scatterlist));
 
+               SET_SG_TABLE(sg, sg_per_table);
+
                sg_table[i].sg_table = sg;
                sg_table[i].rd_sg_count = sg_per_table;
                sg_table[i].page_start_offset = page_offset;
Index: target/iscsi_target_transport.c
===================================================================
--- target/iscsi_target_transport.c     (revision 215)
+++ target/iscsi_target_transport.c     (revision 217)
@@ -5096,6 +5096,8 @@
        }
        memset(task->task_buf, 0, task->task_sg_num * sizeof(struct scatterlist));
 
+       SET_SG_TABLE(task->task_buf, task->task_sg_num);
+
        DEBUG_SC("Successfully allocated task->task_sg_num: %u\n", task->task_sg_num);
        
        return(task->task_sg_num);

On Sun, 2008-02-10 at 14:26 -0500, Mark Tuttle wrote:
> Thanks for that information, I analysed your code to get a better
> understanding of exactly what was going on and was able to
> successfully patch what I needed to.
> 
> http://www.tuttleresearch.com/80211patch.html
> 
> Much appreciated,
> Mark Tuttle
> 
> On 2/9/08, Nicholas A. Bellinger <nab@linux-iscsi.org> wrote:
> > On Sat, 2008-02-09 at 01:28 -0500, Mark Tuttle wrote:
> > > Regarding:
> > > commit 18dabf473e15850c0dbc8ff13ac1e2806d542c15
> > >
> > > This actually breaks the 802.11 subsystem (http://80211.sf.net) which
> > > relies on the page struct. (ieee80211_crypt_wep.c, line 190) Can
> > > anyone suggest an alternative kernel function or method? As of 2.6.24,
> > > the 802.11 subsystem cannot compile.
> > >
> >
> > Greetings Mark,
> >
> > I have been updating the LIO-Target codebase to 2.6.24 recently, and
> > posted some information about what I ended up doing for struct
> > scatterlist->page changing to scatterlist->page_link and
> > include/linux/scatterlist.h
> >
> > http://lkml.org/lkml/2008/2/4/111
> >
> > Hope this helps,
> >
> > --nab
> >
> >
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

