Return-Path: <linux-kernel-owner+w=401wt.eu-S1759297AbYGFS3T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759297AbYGFS3T (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jul 2008 14:29:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755107AbYGFS3J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Jul 2008 14:29:09 -0400
Received: from ch-smtp02.sth.basefarm.net ([80.76.149.213]:40736 "EHLO
	ch-smtp02.sth.basefarm.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755200AbYGFS3I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jul 2008 14:29:08 -0400
Cc: LKML <linux-kernel@vger.kernel.org>,
       kernelnewbies <kernelnewbies@nl.linux.org>,
       kernel-janitors <kernel-janitors@vger.kernel.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Lars Brinkhoff <lars@nocrew.org>,
       =?ISO-8859-1?Q?Tomas_Sk=E4re?= <tomas@nocrew.org>
Message-Id: <35647D7D-85D1-4308-B3A1-63CDCC3F14F7@nocrew.org>
From: Fredrik Noring <noring@nocrew.org>
To: David Woodhouse <dwmw2@infradead.org>,
       Jaswinder Singh <jaswinder@infradead.org>
In-Reply-To: <1215363247.3189.113.camel@shinybook.infradead.org>
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (Apple Message framework v926)
Subject: Re: [PATCH] dsp56k: use request_firmware
Date: Sun, 6 Jul 2008 20:29:04 +0200
References: <1215253496.7816.7.camel@jaswinder.satnam> <A3D470E0-953E-40D6-BF5A-D06B76451154@nocrew.org> <1215357224.2817.2.camel@jaswinder.satnam> <43A34816-3B93-4D05-AE0A-65C0FBF35589@nocrew.org> <1215358732.2817.11.camel@jaswinder.satnam> <1215363247.3189.113.camel@shinybook.infradead.org>
X-Mailer: Apple Mail (2.926)
X-Originating-IP: 83.252.213.252
X-ACL-Warn: Too high rate of unknown addresses received from you
X-Scan-Result: No virus found in message 1KFYyv-00076E-7j.
X-Scan-Signature: ch-smtp02.sth.basefarm.net 1KFYyv-00076E-7j 427ca2bc354e32e1364318c52b7119a3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi David,

6 jul 2008 kl. 18.54 skrev David Woodhouse:
> I don't think he has it. That's why he suggested a disassembler.

That's right. Sorry I was unclear. However, after some digging on  
floppy backups from the past, I've found a DSP56k loader routine  
that's probably close if not identical to the assembled version  
included with the kernel. Please see below. A disassembly would verify  
this, but at least it gives you an idea of the inner workings.

All the best,
Fredrik

; DSP56k loader

; Host Interface
M_BCR   EQU     $FFFE           ; Port A Bus Control Register
M_PBC   EQU     $FFE0           ; Port B Control Register
M_PBDDR EQU     $FFE2           ; Port B Data Direction Register
M_PBD   EQU     $FFE4           ; Port B Data Register
M_PCC   EQU     $FFE1           ; Port C Control Register
M_PCDDR EQU     $FFE3           ; Port C Data Direction Register
M_PCD   EQU     $FFE5           ; Port C Data Register

M_HCR   EQU     $FFE8           ; Host Control Register
M_HSR   EQU     $FFE9           ; Host Status Register
M_HRX   EQU     $FFEB           ; Host Receive Data Register
M_HTX   EQU     $FFEB           ; Host Transmit Data Register

; SSI, Synchronous Serial Interface
M_RX    EQU     $FFEF           ; Serial Receive Data Register
M_TX    EQU     $FFEF           ; Serial Transmit Data Register
M_CRA   EQU     $FFEC           ; SSI Control Register A
M_CRB   EQU     $FFED           ; SSI Control Register B
M_SR    EQU     $FFEE           ; SSI Status Register
M_TSR   EQU     $FFEE           ; SSI Time Slot Register

; Exception Processing
M_IPR   EQU     $FFFF           ; Interrupt Priority Register

	org	P:$0
start	jmp	<$40

	org	P:$40
;	; Zero 16384 DSP X and Y words
;	clr	A #0,r0
;	clr	B #0,r4
;	do	#64,<_block1
;	rep	#256
;	move	A,X:(r0)+ B,Y:(r4)+
;_block1	; Zero (32768-512) Program words
;	clr	A #512,r0
;	do	#126,<_block2
;	rep	#256
;	move	A,P:(r0)+
;_block2

	; Copy DSP program control
	move	#real,r0
	move	#upload,r1
	do	#upload_end-upload,<_copy
	move	P:(r0)+,x0
	move	x0,P:(r1)+
_copy	movep	#>4,X:<<M_HCR
	movep	#>$c00,X:<<M_IPR
	and	#<$fe,mr
	jmp	upload

real
	org	P:$7ea9
upload
	movep	#>1,X:<<M_PBC
	movep	#>0,X:<<M_BCR

next	jclr	#0,X:<<M_HSR,*
	movep	X:<<M_HRX,A
	move	#>3,x0
	cmp	x0,A #>1,x0
	jeq	<$0
_get_address
	jclr	#0,X:<<M_HSR,_get_address
	movep	X:<<M_HRX,r0
_get_length
	jclr	#0,X:<<M_HSR,_get_length
	movep	X:<<M_HRX,y0
	cmp	x0,A #>2,x0
	jeq	load_X
	cmp	x0,A
	jeq	load_Y

load_P	do	y0,_load
	jclr	#0,X:<<M_HSR,*
	movep	X:<<M_HRX,P:(r0)+
_load	jmp	next
load_X	do	y0,_load
	jclr	#0,X:<<M_HSR,*
	movep	X:<<M_HRX,X:(r0)+
_load	jmp	next
load_Y	do	y0,_load
	jclr	#0,X:<<M_HSR,*
	movep	X:<<M_HRX,Y:(r0)+
_load	jmp	next

upload_end
	end

