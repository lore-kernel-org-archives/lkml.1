Return-Path: <linux-kernel-owner+w=401wt.eu-S1754977AbZBBPrl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754977AbZBBPrl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Feb 2009 10:47:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752673AbZBBPrc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Feb 2009 10:47:32 -0500
Received: from mail.perle.com ([216.129.13.248]:2175 "EHLO MAILV6.PERLE.COM"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751557AbZBBPrb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Feb 2009 10:47:31 -0500
In-Reply-To: <20090129193440.2c6efb65@lxorguk.ukuu.org.uk>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 60/80] tty: extract the pty init time special cases
MIME-Version: 1.0
Sensitivity: 
X-Mailer: Lotus Notes Release 6.5 September 26, 2003
Message-ID: <OF3207513C.B2AADC83-ON8525754E.007B165D-85257551.0056C108@perle.com>
From: bmckinlay@perle.com
Date: Mon, 2 Feb 2009 10:42:49 -0500
X-MIMETrack: Serialize by Router on MAILV6/Perle(Release 6.5.6FP3|March 27, 2008) at 02/02/2009
 10:42:28 AM,
	Serialize complete at 02/02/2009 10:42:28 AM
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> The first most useful part would be understand what your pty driver does
> and is required that is not in the base one. Just an idea of what extra
> APIs it provides would be quite useful. If it is stuff like virtual 
modem
> lines then that is stuff I want to see supported in the base kernel
> anyway.

Our pty driver basically creates a virtual serial TTY on the slave side 
which 
will allow the application to control a remote device server serial port 
across a LAN network.  The application can control things like baud rate,
parity, stop bits, HW & SW flow control, and monitor and control modem 
signals. 

Below are some defines that would explain how we extended the base pty.
One note is the our diver is based on the legacy/bsd pty not the unix98
pty, so if it was decided that this extension was to be merged into the
base pty then the code would have to be ported to the unix98 sections as
well.

/* 
   There aren't enough bits available in tty->ctrl_status for the events 
that
   we need to signal to the daemon, so we will use 1 bit to indicate that
   the daemon needs to make an IOCTL (PTX_IOCXCSGET) to get the real 
status.
*/
#define TIOCPKT_XCTRLSTATUS     0x40

//  bit definition for ptyx_struct.ctrl_status
#define XCTRLSTATUS_SIGNALS     0x00000001      // update DTR, RTS signals
#define XCTRLSTATUS_TERMIOS     0x00000002      // update termios settings
#define XCTRLSTATUS_BREAK       0x00000004      // send break signal
#define XCTRLSTATUS_OPEN        0x00000008      // slave port opened
#define XCTRLSTATUS_CLOSE       0x00000010      // slave port closed
#define XCTRLSTATUS_BREAKON     0x00000020      // send break on
#define XCTRLSTATUS_BREAKOFF    0x00000040      // send break off
#define XCTRLSTATUS_DRAIN       0x00000080      // drain port

// IOCTLs handled by master ptyx driver
#define PTX_IOC         ('p' << 24) + ('t' << 16) + ('x' << 8)
#define PTX_IOCMSET     PTX_IOC + 1     // set modem signal
#define PTX_IOCLSET     PTX_IOC + 2     // set line status info
#define PTX_IOCXCSGET   PTX_IOC + 3     // get extended control status
#define PTX_IOCDRAINEND PTX_IOC + 4     // drain complete
#define PTX_IOCNETSTAT  PTX_IOC + 5     // update network
#define PTX_IOCOWTSET   PTX_IOC + 6     // give ptyx, the open wait time 
in msec
                                                // -1=ignore network 
status, -2=wait forever



 


  Barry
