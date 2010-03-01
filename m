Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751618Ab0CAQzr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Mar 2010 11:55:47 -0500
Received: from [206.15.93.42] ([206.15.93.42]:10791 "EHLO
	visionfs1.visionengravers.com" rhost-flags-FAIL-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751269Ab0CAQzp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Mar 2010 11:55:45 -0500
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] dt3155: replace {Write | Read}MReg with {write | read}l
Date: Mon, 1 Mar 2010 09:55:40 -0700
Cc: greg@kroah.com, ss@aao.gov.au
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201003010955.40981.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The WriteMReg and ReadMReg macros are really just renamed versions
of writel and readl. Use the kernel provided versions instead.

Also, the ioremap returns a void __iomem * not a u8 *. Fix all the users
of dt3155_lbase to reflect this.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Greg Kroah-Hartman <greg@kroah.com>
Cc: Scott Smedley <ss@aao.gov.au>

---

diff --git a/drivers/staging/dt3155/dt3155_drv.c b/drivers/staging/dt3155/dt3155_drv.c
index a67c622..c0f8abf 100644
--- a/drivers/staging/dt3155/dt3155_drv.c
+++ b/drivers/staging/dt3155/dt3155_drv.c
@@ -122,7 +122,7 @@ int dt3155_major = 0;
 struct dt3155_status_s dt3155_status[ MAXBOARDS ];
 
 /* kernel logical address of the board */
-u8 *dt3155_lbase[ MAXBOARDS ] = { NULL
+void __iomem *dt3155_lbase[MAXBOARDS] = { NULL
 #if MAXBOARDS == 2
 				      , NULL
 #endif
@@ -149,11 +149,11 @@ static void quick_stop (int minor)
 {
   // TODO: scott was here
 #if 1
-  ReadMReg((dt3155_lbase[ minor ] + INT_CSR), int_csr_r.reg);
+  int_csr_r.reg = readl(dt3155_lbase[minor] + INT_CSR);
   /* disable interrupts */
   int_csr_r.fld.FLD_END_EVE_EN = 0;
   int_csr_r.fld.FLD_END_ODD_EN = 0;
-  WriteMReg((dt3155_lbase[ minor ] + INT_CSR), int_csr_r.reg );
+  writel(int_csr_r.reg, dt3155_lbase[minor] + INT_CSR);
 
   dt3155_status[ minor ].state &= ~(DT3155_STATE_STOP|0xff);
   /* mark the system stopped: */
@@ -198,7 +198,7 @@ static inline void dt3155_isr( int irq, void *dev_id, struct pt_regs *regs )
   }
 
   /* Check for corruption and set a flag if so */
-  ReadMReg( (dt3155_lbase[ minor ] + CSR1), csr1_r.reg );
+  csr1_r.reg = readl(dt3155_lbase[minor] + CSR1);
 
   if ( (csr1_r.fld.FLD_CRPT_EVE) || (csr1_r.fld.FLD_CRPT_ODD) )
     {
@@ -210,7 +210,7 @@ static inline void dt3155_isr( int irq, void *dev_id, struct pt_regs *regs )
       return;
     }
 
-  ReadMReg((dt3155_lbase[ minor ] + INT_CSR), int_csr_r.reg);
+  int_csr_r.reg = readl(dt3155_lbase[minor] + INT_CSR);
 
   /* Handle the even field ... */
   if (int_csr_r.fld.FLD_END_EVE)
@@ -221,7 +221,7 @@ static inline void dt3155_isr( int irq, void *dev_id, struct pt_regs *regs )
 	  dt3155_fbuffer[ minor ]->frame_count++;
 	}
 
-      ReadI2C(dt3155_lbase[ minor ], EVEN_CSR, &i2c_even_csr.reg);
+      ReadI2C(dt3155_lbase[minor], EVEN_CSR, &i2c_even_csr.reg);
 
       /* Clear the interrupt? */
       int_csr_r.fld.FLD_END_EVE = 1;
@@ -241,7 +241,7 @@ static inline void dt3155_isr( int irq, void *dev_id, struct pt_regs *regs )
 	    }
 	}
 
-      WriteMReg( (dt3155_lbase[ minor ] + INT_CSR), int_csr_r.reg );
+      writel(int_csr_r.reg, dt3155_lbase[minor] + INT_CSR);
 
       /* Set up next DMA if we are doing FIELDS */
       if ( (dt3155_status[ minor ].state & DT3155_STATE_MODE ) ==
@@ -259,7 +259,7 @@ static inline void dt3155_isr( int irq, void *dev_id, struct pt_regs *regs )
 
 	  /* Set up the DMA address for the next field */
 	  local_irq_restore(flags);
-	  WriteMReg((dt3155_lbase[ minor ] + ODD_DMA_START), buffer_addr);
+	  writel(buffer_addr, dt3155_lbase[minor] + ODD_DMA_START);
 	}
 
       /* Check for errors. */
@@ -267,7 +267,7 @@ static inline void dt3155_isr( int irq, void *dev_id, struct pt_regs *regs )
       if ( i2c_even_csr.fld.ERROR_EVE )
 	dt3155_errno = DT_ERR_OVERRUN;
 
-      WriteI2C( dt3155_lbase[ minor ], EVEN_CSR, i2c_even_csr.reg );
+      WriteI2C(dt3155_lbase[minor], EVEN_CSR, i2c_even_csr.reg);
 
       /* Note that we actually saw an even field meaning  */
       /* that subsequent odd field complete the frame     */
@@ -284,7 +284,7 @@ static inline void dt3155_isr( int irq, void *dev_id, struct pt_regs *regs )
   /* ... now handle the odd field */
   if ( int_csr_r.fld.FLD_END_ODD )
     {
-      ReadI2C( dt3155_lbase[ minor ], ODD_CSR, &i2c_odd_csr.reg );
+      ReadI2C(dt3155_lbase[minor], ODD_CSR, &i2c_odd_csr.reg);
 
       /* Clear the interrupt? */
       int_csr_r.fld.FLD_END_ODD = 1;
@@ -320,7 +320,7 @@ static inline void dt3155_isr( int irq, void *dev_id, struct pt_regs *regs )
 	    }
 	}
 
-      WriteMReg( (dt3155_lbase[ minor ] + INT_CSR), int_csr_r.reg );
+      writel(int_csr_r.reg, dt3155_lbase[minor] + INT_CSR);
 
       /* if the odd field has been acquired, then     */
       /* change the next dma location for both fields */
@@ -395,16 +395,13 @@ static inline void dt3155_isr( int irq, void *dev_id, struct pt_regs *regs )
       buffer_addr = dt3155_fbuffer[ minor ]->
 	frame_info[ dt3155_fbuffer[ minor ]->active_buf ].addr;
       if ( (dt3155_status[ minor ].state & DT3155_STATE_MODE) ==
-	   DT3155_STATE_FLD )
-	{
-	  WriteMReg((dt3155_lbase[ minor ] + EVEN_DMA_START), buffer_addr);
-	}
-      else
-	{
-	  WriteMReg((dt3155_lbase[ minor ] + EVEN_DMA_START), buffer_addr);
+	   DT3155_STATE_FLD ) {
+	  writel(buffer_addr, dt3155_lbase[minor] + EVEN_DMA_START);
+	} else {
+	  writel(buffer_addr, dt3155_lbase[minor] + EVEN_DMA_START);
 
-	  WriteMReg((dt3155_lbase[ minor ] + ODD_DMA_START), buffer_addr
-		    + dt3155_status[ minor ].config.cols);
+	  writel(buffer_addr + dt3155_status[minor].config.cols,
+		    dt3155_lbase[minor] + ODD_DMA_START);
 	}
 
       /* Do error checking */
@@ -412,7 +409,7 @@ static inline void dt3155_isr( int irq, void *dev_id, struct pt_regs *regs )
       if ( i2c_odd_csr.fld.ERROR_ODD )
 	dt3155_errno = DT_ERR_OVERRUN;
 
-      WriteI2C(dt3155_lbase[ minor ], ODD_CSR, i2c_odd_csr.reg );
+      WriteI2C(dt3155_lbase[minor], ODD_CSR, i2c_odd_csr.reg);
 
       return;
     }
@@ -439,12 +436,9 @@ static void dt3155_init_isr(int minor)
 	even_dma_stride_r = 0;
 	odd_dma_stride_r  = 0;
 
-	WriteMReg((dt3155_lbase[ minor ] + EVEN_DMA_START),
-		  even_dma_start_r);
-	WriteMReg((dt3155_lbase[ minor ] + EVEN_DMA_STRIDE),
-		  even_dma_stride_r);
-	WriteMReg((dt3155_lbase[ minor ] + ODD_DMA_STRIDE),
-		  odd_dma_stride_r);
+	writel(even_dma_start_r, dt3155_lbase[minor] + EVEN_DMA_START);
+	writel(even_dma_stride_r, dt3155_lbase[minor] + EVEN_DMA_STRIDE);
+	writel(odd_dma_stride_r, dt3155_lbase[minor] + ODD_DMA_STRIDE);
 	break;
       }
 
@@ -457,14 +451,10 @@ static void dt3155_init_isr(int minor)
 	even_dma_stride_r =  stride;
 	odd_dma_stride_r  =  stride;
 
-	WriteMReg((dt3155_lbase[ minor ] + EVEN_DMA_START),
-		  even_dma_start_r);
-	WriteMReg((dt3155_lbase[ minor ] + ODD_DMA_START),
-		  odd_dma_start_r);
-	WriteMReg((dt3155_lbase[ minor ] + EVEN_DMA_STRIDE),
-		  even_dma_stride_r);
-	WriteMReg((dt3155_lbase[ minor ] + ODD_DMA_STRIDE),
-		  odd_dma_stride_r);
+	writel(even_dma_start_r, dt3155_lbase[minor] + EVEN_DMA_START);
+	writel(odd_dma_start_r, dt3155_lbase[minor] + ODD_DMA_START);
+	writel(even_dma_stride_r, dt3155_lbase[minor] + EVEN_DMA_STRIDE);
+	writel(odd_dma_stride_r, dt3155_lbase[minor] + ODD_DMA_STRIDE);
 	break;
       }
     }
@@ -472,9 +462,9 @@ static void dt3155_init_isr(int minor)
   /* 50/60 Hz should be set before this point but let's make sure it is */
   /* right anyway */
 
-  ReadI2C(dt3155_lbase[ minor ], CONFIG, &i2c_csr2.reg);
+  ReadI2C(dt3155_lbase[minor], CONFIG, &i2c_csr2.reg);
   i2c_csr2.fld.HZ50 = FORMAT50HZ;
-  WriteI2C(dt3155_lbase[ minor ], CONFIG, i2c_config.reg);
+  WriteI2C(dt3155_lbase[minor], CONFIG, i2c_config.reg);
 
   /* enable busmaster chip, clear flags */
 
@@ -494,7 +484,7 @@ static void dt3155_init_isr(int minor)
   csr1_r.fld.FLD_CRPT_EVE   = 1; /* writing a 1 clears flags */
   csr1_r.fld.FLD_CRPT_ODD   = 1;
 
-  WriteMReg((dt3155_lbase[ minor ] + CSR1),csr1_r.reg);
+  writel(csr1_r.reg, dt3155_lbase[minor] + CSR1);
 
   /* Enable interrupts at the end of each field */
 
@@ -503,14 +493,14 @@ static void dt3155_init_isr(int minor)
   int_csr_r.fld.FLD_END_ODD_EN = 1;
   int_csr_r.fld.FLD_START_EN = 0;
 
-  WriteMReg((dt3155_lbase[ minor ] + INT_CSR), int_csr_r.reg);
+  writel(int_csr_r.reg, dt3155_lbase[minor] + INT_CSR);
 
   /* start internal BUSY bits */
 
-  ReadI2C(dt3155_lbase[ minor ], CSR2, &i2c_csr2.reg);
+  ReadI2C(dt3155_lbase[minor], CSR2, &i2c_csr2.reg);
   i2c_csr2.fld.BUSY_ODD  = 1;
   i2c_csr2.fld.BUSY_EVE  = 1;
-  WriteI2C(dt3155_lbase[ minor ], CSR2, i2c_csr2.reg);
+  WriteI2C(dt3155_lbase[minor], CSR2, i2c_csr2.reg);
 
   /* Now its up to the interrupt routine!! */
 
@@ -718,7 +708,7 @@ static int dt3155_open( struct inode* inode, struct file* filep)
 
   /* Disable ALL interrupts */
   int_csr_r.reg = 0;
-  WriteMReg( (dt3155_lbase[ minor ] + INT_CSR), int_csr_r.reg );
+  writel(int_csr_r.reg, dt3155_lbase[minor] + INT_CSR);
 
   init_waitqueue_head(&(dt3155_read_wait_queue[minor]));
 
@@ -909,12 +899,10 @@ static int find_PCI (void)
 
       /* Remap the base address to a logical address through which we
        * can access it. */
-      dt3155_lbase[ pci_index - 1 ] = ioremap(base,PCI_PAGE_SIZE);
-      dt3155_status[ pci_index - 1 ].reg_addr = base;
+      dt3155_lbase[pci_index-1] = ioremap(base, PCI_PAGE_SIZE);
       DT_3155_DEBUG_MSG("DT3155: New logical address is %p \n",
 			dt3155_lbase[pci_index-1]);
-      if ( !dt3155_lbase[pci_index-1] )
-	{
+      if (!dt3155_lbase[pci_index-1]) {
 	  printk("DT3155: Unable to remap control registers\n");
 	  goto err;
 	}
@@ -1034,7 +1022,7 @@ int init_module(void)
   int_csr_r.reg = 0;
   for(  index = 0;  index < ndevices;  index++ )
     {
-      WriteMReg( (dt3155_lbase[ index ] + INT_CSR), int_csr_r.reg );
+      writel(int_csr_r.reg, dt3155_lbase[index] + INT_CSR);
       if( dt3155_status[ index ].device_installed )
 	{
 	  /*
diff --git a/drivers/staging/dt3155/dt3155_io.c b/drivers/staging/dt3155/dt3155_io.c
index 6b9c685..a6da0cd 100644
--- a/drivers/staging/dt3155/dt3155_io.c
+++ b/drivers/staging/dt3155/dt3155_io.c
@@ -79,7 +79,7 @@ u8 i2c_pm_lut_data;
  * Returns FALSE if NEW_CYCLE doesn't clear in roughly 3 msecs, otherwise
  * returns 0
  */
-static int wait_ibsyclr(u8 *lpReg)
+static int wait_ibsyclr(void __iomem *lpReg)
 {
 	/* wait 100 microseconds */
 	udelay(100L);
@@ -105,13 +105,13 @@ static int wait_ibsyclr(u8 *lpReg)
  * Returns TRUE   -  Successful completion
  *         FALSE  -  Timeout error - cycle did not complete!
  */
-int WriteI2C(u8 *lpReg, u_short wIregIndex, u8 byVal)
+int WriteI2C(void __iomem *lpReg, u_short wIregIndex, u8 byVal)
 {
 	int writestat;	/* status for return */
 
 	/* read 32 bit IIC_CSR2 register data into union */
 
-	ReadMReg((lpReg + IIC_CSR2), iic_csr2_r.reg);
+	iic_csr2_r.reg = readl(lpReg + IIC_CSR2);
 
 	/* for write operation */
 	iic_csr2_r.fld.DIR_RD      = 0;
@@ -123,7 +123,7 @@ int WriteI2C(u8 *lpReg, u_short wIregIndex, u8 byVal)
 	iic_csr2_r.fld.NEW_CYCLE   = 1;
 
 	/* xfer union data into 32 bit IIC_CSR2 register */
-	WriteMReg((lpReg + IIC_CSR2), iic_csr2_r.reg);
+	writel(iic_csr2_r.reg, lpReg + IIC_CSR2);
 
 	/* wait for IIC cycle to finish */
 	writestat = wait_ibsyclr(lpReg);
@@ -142,12 +142,12 @@ int WriteI2C(u8 *lpReg, u_short wIregIndex, u8 byVal)
  * Returns TRUE   -  Successful completion
  *         FALSE  -  Timeout error - cycle did not complete!
  */
-int ReadI2C(u8 *lpReg, u_short wIregIndex, u8 *byVal)
+int ReadI2C(void __iomem *lpReg, u_short wIregIndex, u8 *byVal)
 {
 	int writestat;	/* status for return */
 
 	/*  read 32 bit IIC_CSR2 register data into union */
-	ReadMReg((lpReg + IIC_CSR2), iic_csr2_r.reg);
+	iic_csr2_r.reg = readl(lpReg + IIC_CSR2);
 
 	/*  for read operation */
 	iic_csr2_r.fld.DIR_RD     = 1;
@@ -159,14 +159,14 @@ int ReadI2C(u8 *lpReg, u_short wIregIndex, u8 *byVal)
 	iic_csr2_r.fld.NEW_CYCLE  = 1;
 
 	/*  xfer union's data into 32 bit IIC_CSR2 register */
-	WriteMReg((lpReg + IIC_CSR2), iic_csr2_r.reg);
+	writel(iic_csr2_r.reg, lpReg + IIC_CSR2);
 
 	/* wait for IIC cycle to finish */
 	writestat = wait_ibsyclr(lpReg);
 
 	/* Next 2 commands read 32 bit IIC_CSR1 register's data into union */
 	/* first read data is in IIC_CSR1 */
-	ReadMReg((lpReg + IIC_CSR1), iic_csr1_r.reg);
+	iic_csr1_r.reg = readl(lpReg + IIC_CSR1);
 
 	/* now get data u8 out of register */
 	*byVal = (u8) iic_csr1_r.fld.RD_DATA;
diff --git a/drivers/staging/dt3155/dt3155_io.h b/drivers/staging/dt3155/dt3155_io.h
index d1a2510..08f416a 100644
--- a/drivers/staging/dt3155/dt3155_io.h
+++ b/drivers/staging/dt3155/dt3155_io.h
@@ -34,11 +34,6 @@ MA 02111-1307 USA
 #ifndef DT3155_IO_INC
 #define DT3155_IO_INC
 
-/* macros to access registers */
-
-#define WriteMReg(Address, Data)	(*((u32 *)(Address)) = Data)
-#define ReadMReg(Address, Data)		(Data = *((u32 *)(Address)))
-
 /***************** 32 bit register globals  **************/
 
 /*  offsets for 32-bit memory mapped registers */
@@ -352,7 +347,7 @@ extern u8			i2c_pm_lut_data;
 
 /* access 8-bit IIC registers */
 
-extern int ReadI2C(u8 *lpReg, u_short wIregIndex, u8 *byVal);
-extern int WriteI2C(u8 *lpReg, u_short wIregIndex, u8 byVal);
+extern int ReadI2C(void __iomem *lpReg, u_short wIregIndex, u8 *byVal);
+extern int WriteI2C(void __iomem *lpReg, u_short wIregIndex, u8 byVal);
 
 #endif
