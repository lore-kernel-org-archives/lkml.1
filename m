Return-Path: <linux-kernel-owner+w=401wt.eu-S932130AbXFASlk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932130AbXFASlk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2007 14:41:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760441AbXFASlc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Jun 2007 14:41:32 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:54624 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760938AbXFASlb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2007 14:41:31 -0400
Message-ID: <46606851.3060905@pobox.com>
Date: Fri, 01 Jun 2007 14:41:21 -0400
From: Jeff Garzik <jgarzik@pobox.com>
User-Agent: Thunderbird 1.5.0.12 (X11/20070530)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Tejun Heo <htejun@gmail.com>, Gregor Jasny <gjasny@googlemail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-ide@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: Linux v2.6.22-rc3
References: <alpine.LFD.0.98.0705252008210.26602@woody.linux-foundation.org> <9d2cd630705270801m2826be60p3f802c502b26c531@mail.gmail.com>  <46599E6B.1000209@pobox.com>  <9d2cd630705270907y4722653cpf79f073fa8f12f08@mail.gmail.com> <alpine.LFD.0.98.0705270922030.26602@woody.linux-foundation.org>  <9d2cd630705271315x7030c91ew2f175c921c022880@mail.gmail.com>  <465AA536.6080608@gmail.com> <9d2cd630705280707h4921900fxc93a07a87f0bdf66@mail.gmail.com> <465BF244.5080200@gmail.com> <alpine.LFD.0.98.0705290924350.26602@woody.linux-foundation.org> <465F6F48.8080804@gmail.com> <alpine.LFD.0.98.0705311830360.26602@woody.linux-foundation.org> <465F8230.2040105@gmail.com> <46604E62.1000105@pobox.com> <alpine.LFD.0.98.0706010955390.3957@woody.linux-foundation.org> <466058F8.4050107@pobox.com> <alpine.LFD.0.98.0706011047000.3957@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.0.98.0706011047000.3957@woody.linux-foundation.org>
Content-Type: multipart/mixed;
 boundary="------------010602000001070303060900"
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.8 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------010602000001070303060900
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Linus Torvalds wrote:
> 
> On Fri, 1 Jun 2007, Jeff Garzik wrote:
>> With these old PATA devices, device reset is "six of one, half-dozen of the
>> other."  Using SRST is the only way to kick some ATAPI devices into working:
>> http://suif.stanford.edu/~csapuntz/blackmagic.html#reset
> 
> Well, wouldn't it be a good thing to
>  1) if BUSY/DRQ is set even before you try the problem, obviously skip the 
>     two polite cases, and go to #4
>  2) try to just do an IDENTIFY 
>  3) if that doesn't work, do a HOST RESET and then try again
>  4) if that doesn't work, do the full SRST
> 
> (or some variation of the above).

Skipping reset means it doesn't get the device away from a state that 
the previous boot may have configured itself to... standard "I didn't do 
reset" problems you see with any hardware.  Transfer modes and 
removeable media status notification are the most notable that are left 
in a semi-random state, but there are many other minor feature bits that 
fall into this category as well.


> (Btw, the 150ms wait after reset is really nasty. A few of those, and 
> we're wasting seconds during bootup. Why the hell does it do that, when 
> the old driver - and the spec - said 2ms?)

Upon quick review, it appears it should be 110ms.  And actually the spec 
says 3ms.  But to answer your question anyway... :)

The basic libata probe came from the code procedure that is found in a 
lot of PC BIOSen, even (IMO) more exposure than Linux:  Hale Landis's 
ATADRVR.  See the attached code sample for the relevant procedure, or 
the entire driver source code (PC DOS-style) at 
http://www.ata-atapi.com/atadrvr.zip

Upon further review, it looks like the 110ms delay is only per-ATAPI 
command, not during reset, as the sub_atapi_delay() calls don't actually 
delay before the ATAPI signature has been detected.


> I thought the default in Fedora was to use the PATA driver first? If so, 

<grin>  (see davej's reply)

	Jeff



--------------010602000001070303060900
Content-Type: text/plain;
 name="example.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="example.txt"


//*************************************************************
//
// reg_config() - Check the host adapter and determine the
//                number and type of drives attached.
//
// This process is not documented by any of the ATA standards.
//
// Infomation is returned by this function is in
// reg_config_info[] -- see ATAIO.H.
//
//*************************************************************

int reg_config( void )

{
   int numDev = 0;
   unsigned char sc;
   unsigned char sn;
   unsigned char cl;
   unsigned char ch;
   unsigned char st;
   unsigned char devCtrl;

   // setup register values

   devCtrl = CB_DC_HD15 | ( int_use_intr_flag ? 0 : CB_DC_NIEN );

   // mark start of config in low level trace

   trc_llt( 0, 0, TRC_LLT_S_CFG );

   // assume there are no devices

   reg_config_info[0] = REG_CONFIG_TYPE_NONE;
   reg_config_info[1] = REG_CONFIG_TYPE_NONE;

   // set up Device Control register

   pio_outbyte( CB_DC, devCtrl );

   // lets see if there is a device 0

   pio_outbyte( CB_DH, CB_DH_DEV0 );
   DELAY400NS;
   pio_outbyte( CB_SC, 0x55 );
   pio_outbyte( CB_SN, 0xaa );
   pio_outbyte( CB_SC, 0xaa );
   pio_outbyte( CB_SN, 0x55 );
   pio_outbyte( CB_SC, 0x55 );
   pio_outbyte( CB_SN, 0xaa );
   sc = pio_inbyte( CB_SC );
   sn = pio_inbyte( CB_SN );
   if ( ( sc == 0x55 ) && ( sn == 0xaa ) )
      reg_config_info[0] = REG_CONFIG_TYPE_UNKN;

   // lets see if there is a device 1

   pio_outbyte( CB_DH, CB_DH_DEV1 );
   DELAY400NS;
   pio_outbyte( CB_SC, 0x55 );
   pio_outbyte( CB_SN, 0xaa );
   pio_outbyte( CB_SC, 0xaa );
   pio_outbyte( CB_SN, 0x55 );
   pio_outbyte( CB_SC, 0x55 );
   pio_outbyte( CB_SN, 0xaa );
   sc = pio_inbyte( CB_SC );
   sn = pio_inbyte( CB_SN );
   if ( ( sc == 0x55 ) && ( sn == 0xaa ) )
      reg_config_info[1] = REG_CONFIG_TYPE_UNKN;

   // now we think we know which devices, if any are there,
   // so lets try a soft reset (ignoring any errors).

   pio_outbyte( CB_DH, CB_DH_DEV0 );
   DELAY400NS;
   reg_reset( 0, 0 );

   // lets check device 0 again, is device 0 really there?
   // is it ATA or ATAPI?

   pio_outbyte( CB_DH, CB_DH_DEV0 );
   DELAY400NS;
   sc = pio_inbyte( CB_SC );
   sn = pio_inbyte( CB_SN );
   if ( ( sc == 0x01 ) && ( sn == 0x01 ) )
   {
      reg_config_info[0] = REG_CONFIG_TYPE_UNKN;
      cl = pio_inbyte( CB_CL );
      ch = pio_inbyte( CB_CH );
      st = pio_inbyte( CB_STAT );
      if ( ( cl == 0x14 ) && ( ch == 0xeb ) )
         reg_config_info[0] = REG_CONFIG_TYPE_ATAPI;
      else
         if ( ( cl == 0x00 ) && ( ch == 0x00 ) && ( st != 0x00 ) )
            reg_config_info[0] = REG_CONFIG_TYPE_ATA;
   }

   // lets check device 1 again, is device 1 really there?
   // is it ATA or ATAPI?

   pio_outbyte( CB_DH, CB_DH_DEV1 );
   DELAY400NS;
   sc = pio_inbyte( CB_SC );
   sn = pio_inbyte( CB_SN );
   if ( ( sc == 0x01 ) && ( sn == 0x01 ) )
   {
      reg_config_info[1] = REG_CONFIG_TYPE_UNKN;
      cl = pio_inbyte( CB_CL );
      ch = pio_inbyte( CB_CH );
      st = pio_inbyte( CB_STAT );
      if ( ( cl == 0x14 ) && ( ch == 0xeb ) )
         reg_config_info[1] = REG_CONFIG_TYPE_ATAPI;
      else
         if ( ( cl == 0x00 ) && ( ch == 0x00 ) && ( st != 0x00 ) )
            reg_config_info[1] = REG_CONFIG_TYPE_ATA;
   }

   // If possible, select a device that exists, try device 0 first.

   if ( reg_config_info[1] != REG_CONFIG_TYPE_NONE )
   {
      pio_outbyte( CB_DH, CB_DH_DEV1 );
      DELAY400NS;
      numDev ++ ;
   }
   if ( reg_config_info[0] != REG_CONFIG_TYPE_NONE )
   {
      pio_outbyte( CB_DH, CB_DH_DEV0 );
      DELAY400NS;
      numDev ++ ;
   }

   // mark end of config in low level trace

   trc_llt( 0, 0, TRC_LLT_E_CFG );

   // return the number of devices found

   return numDev;
}

//*************************************************************
//
// reg_reset() - Execute a Software Reset.
//
// See ATA-2 Section 9.2, ATA-3 Section 9.2, ATA-4 Section 8.3.
//
//*************************************************************

int reg_reset( int skipFlag, int devRtrn )

{
   unsigned char sc;
   unsigned char sn;
   unsigned char status;
   unsigned char devCtrl;

   // setup register values

   devCtrl = CB_DC_HD15 | ( int_use_intr_flag ? 0 : CB_DC_NIEN );

   // mark start of reset in low level trace

   trc_llt( 0, 0, TRC_LLT_S_RST );

   // Reset error return data.

   sub_zero_return_data();
   reg_cmd_info.flg = TRC_FLAG_SRST;
   reg_cmd_info.ct  = TRC_TYPE_ASR;

   // initialize the command timeout counter

   tmr_set_timeout();

   // Set and then reset the soft reset bit in the Device Control
   // register.  This causes device 0 be selected.

   if ( ! skipFlag )
   {
      pio_outbyte( CB_DC, devCtrl | CB_DC_SRST );
      DELAY400NS;
      pio_outbyte( CB_DC, devCtrl );
      DELAY400NS;
   }

   // If there is a device 0, wait for device 0 to set BSY=0.

   if ( reg_config_info[0] != REG_CONFIG_TYPE_NONE )
   {
      sub_atapi_delay( 0 );
      trc_llt( 0, 0, TRC_LLT_PNBSY );
      while ( 1 )
      {
         status = pio_inbyte( CB_STAT );
         if ( ( status & CB_STAT_BSY ) == 0 )
            break;
         if ( tmr_chk_timeout() )
         {
            trc_llt( 0, 0, TRC_LLT_TOUT );
            reg_cmd_info.to = 1;
            reg_cmd_info.ec = 1;
            trc_llt( 0, reg_cmd_info.ec, TRC_LLT_ERROR );
            break;
         }
      }
   }

   // If there is a device 1, wait until device 1 allows
   // register access.

   if ( reg_config_info[1] != REG_CONFIG_TYPE_NONE )
   {
      sub_atapi_delay( 1 );
      trc_llt( 0, 0, TRC_LLT_PNBSY );
      while ( 1 )
      {
         pio_outbyte( CB_DH, CB_DH_DEV1 );
         DELAY400NS;
         sc = pio_inbyte( CB_SC );
         sn = pio_inbyte( CB_SN );
         if ( ( sc == 0x01 ) && ( sn == 0x01 ) )
            break;
         if ( tmr_chk_timeout() )
         {
            trc_llt( 0, 0, TRC_LLT_TOUT );
            reg_cmd_info.to = 1;
            reg_cmd_info.ec = 2;
            trc_llt( 0, reg_cmd_info.ec, TRC_LLT_ERROR );
            break;
         }
      }

      // Now check if drive 1 set BSY=0.

      if ( reg_cmd_info.ec == 0 )
      {
         if ( pio_inbyte( CB_STAT ) & CB_STAT_BSY )
         {
            reg_cmd_info.ec = 3;
            trc_llt( 0, reg_cmd_info.ec, TRC_LLT_ERROR );
         }
      }
   }

   // RESET_DONE:

   // We are done but now we must select the device the caller
   // requested before we trace the command.  This will cause
   // the correct data to be returned in reg_cmd_info.

   pio_outbyte( CB_DH, devRtrn ? CB_DH_DEV1 : CB_DH_DEV0 );
   DELAY400NS;
   sub_trace_command();

   // If possible, select a device that exists,
   // try device 0 first.

   if ( reg_config_info[1] != REG_CONFIG_TYPE_NONE )
   {
      pio_outbyte( CB_DH, CB_DH_DEV1 );
      DELAY400NS;
   }
   if ( reg_config_info[0] != REG_CONFIG_TYPE_NONE )
   {
      pio_outbyte( CB_DH, CB_DH_DEV0 );
      DELAY400NS;
   }

   // mark end of reset in low level trace

   trc_llt( 0, 0, TRC_LLT_E_RST );

   // All done.  The return values of this function are described in
   // ATAIO.H.

   if ( reg_cmd_info.ec )
      return 1;
   return 0;
}


--------------010602000001070303060900--
