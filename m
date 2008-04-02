Return-Path: <linux-kernel-owner+w=401wt.eu-S1758884AbYDBAjG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758884AbYDBAjG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2008 20:39:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752033AbYDBAiy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Apr 2008 20:38:54 -0400
Received: from terminus.zytor.com ([198.137.202.10]:56501 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751884AbYDBAix (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2008 20:38:53 -0400
Message-ID: <47F2D590.2040300@zytor.com>
Date: Tue, 01 Apr 2008 17:38:40 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: David Newall <davidn@davidnewall.com>
CC: Jan Engelhardt <jengelh@computergmbh.de>, "John T." <j.thomast@yahoo.com>,
       linux-kernel@vger.kernel.org
Subject: Re: UTF-8 and Alt key in the console
References: <205509.99433.qm@web45710.mail.sp1.yahoo.com> <alpine.LNX.1.00.0803231942380.3157@fbirervta.pbzchgretzou.qr> <47ED7EBD.8070009@zytor.com> <alpine.LNX.1.10.0803290055270.18418@fbirervta.pbzchgretzou.qr> <47ED8C13.5060509@zytor.com> <alpine.LNX.1.10.0803290143180.18418@fbirervta.pbzchgretzou.qr> <47EDE2A4.8080702@davidnewall.com> <47EE76BD.2000708@zytor.com> <alpine.LNX.1.10.0804012200340.6604@fbirervta.pbzchgretzou.qr> <47F2CD1B.7060804@davidnewall.com>
In-Reply-To: <47F2CD1B.7060804@davidnewall.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Newall wrote:
> Jan Engelhardt wrote:
>> Hence the proposal of using definite start and end markers:
>>
>>     echo -e '\x1B43m\x1D wonderful \x1B0m\x1D' | cosmicrays | cat
> 
> I see no merit in the idea.  Most seriously, there isn't any real-world
> problem being solved.  In addition, it proposes creating yet another
> type of terminal emulation.  If there's something you don't like about
> VT escape codes, use a different emulation.  For example, Televideo
> terminals used almost exclusively single-character control codes,
> reducing the scope of being mid-sequence to, well much closer to zero.
> 
> You need to make quite clear that your proposal is to discontinue use of
> VT terminal emulation.

Okay, let's put this to rest once and for all:

	*** ISO 6429 sequences are self-terminating. ***

No, you can't tell you're inside one if you miss the leading CSI, but as 
has been pointed out, there really isn't a huge case for it.

The standard is available for free under the name ECMA-48:
http://www.ecma-international.org/publications/files/ECMA-ST/Ecma-048.pdf

It references ISO 2022, a.k.a. ECMA-35:
http://www.ecma-international.org/publications/files/ECMA-ST/Ecma-035.pdf


These standards use a decimalized hexadecimal notation, so if you see 
"05/10" it means 0x5a.  A "column" refers to a 16-character set, so 
"column 4" refers to bytes 0x40 to 0x4f.


The structure defined in section 5.4 of ISO 6429/ECMA-48:

-----------
5.4 Control sequences
A control sequence is a string of bit combinations starting with the 
control function CONTROL SEQUENCE INTRODUCER (CSI) followed by one or 
more bit combinations representing parameters, if any, and by one or 
more bit combinations identifying the control function. The control 
function CSI itself is an element of the C1 set.
The format of a control sequence is
CSI P ... P I ... I F
where
a) CSI is represented by bit combinations 01/11 (representing ESC) and 
05/11 in a 7-bit code or by bit combination 09/11 in an 8-bit code, see 5.3;
b) P ... P are Parameter Bytes, which, if present, consist of bit 
combinations from 03/00 to 03/15;
c) I ... I are Intermediate Bytes, which, if present, consist of bit 
combinations from 02/00 to 02/15. Together with the Final Byte F, they 
identify the control function;
NOTE The number of Intermediate Bytes is not limited by this Standard; 
in practice, one Intermediate Byte will be sufficient since with sixteen 
different bit combinations available for the Intermediate Byte over one 
thousand control functions may be identified.
d) F is the Final Byte; it consists of a bit combination from 04/00 to 
07/14; it terminates the control sequence and together with the 
Intermediate Bytes, if present, identifies the control function. Bit 
combinations 07/00 to 07/14 are available as Final Bytes of control 
sequences for private (or experimental) use.
-----------

Note: DEC added nonstandard control sequences initiated with SS3 (ESC O) 
as well as CSI (ESC [); otherwise they use the same format.

The Final Byte is easy enough to spot, as writing a generic parser which 
can pick this apart, including parameter handling.

	-hpa
