Return-Path: <linux-kernel-owner+w=401wt.eu-S1755920AbYL1VZX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755920AbYL1VZX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Dec 2008 16:25:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755825AbYL1VZB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Dec 2008 16:25:01 -0500
Received: from mailservice.tudelft.nl ([130.161.131.5]:14767 "EHLO
	mailservice.tudelft.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755821AbYL1VY7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Dec 2008 16:24:59 -0500
X-Spam-Flag: NO
X-Spam-Score: -12.489
Message-ID: <4957EEA7.3050101@tudelft.nl>
Date: Sun, 28 Dec 2008 22:24:55 +0100
From: =?ISO-8859-1?Q?=C9ric_Piel?= <E.A.B.Piel@tudelft.nl>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.8.1.18) Gecko/20081120 Mandriva/2.0.0.18-1mdv2009.1 (2009.1) Thunderbird/2.0.0.18 Mnenhy/0.7.5.0
MIME-Version: 1.0
To: Matthew Garrett <mjg59@srcf.ucam.org>
CC: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH, resend] relatime: Let relatime update atime at least
 once per day
References: <20081228152901.GB13565@srcf.ucam.org> <4957CDD2.9040903@tudelft.nl> <20081228195921.GB19176@srcf.ucam.org>
In-Reply-To: <20081228195921.GB19176@srcf.ucam.org>
Content-Type: multipart/mixed;
 boundary="------------040607060101070202090902"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------040607060101070202090902
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit

Matthew Garrett schreef:
> On Sun, Dec 28, 2008 at 08:04:50PM +0100, Éric Piel wrote:
>> Matthew Garrett schreef:
>>> Ensure relatime updates atime at least once per day
>>>     
>>> Allow atime to be updated once per day even with relatime. This lets
>>> utilities like tmpreaper (which delete files based on last access time)
>>> continue working.
>> :
>> Sorry, but I doubt it's a good idea. First, it breaks the simple
>> semantic of relatime (mtime > atime?), mixing it with a rather arbitrary
>> constant. Second, and most important, there are lots of workloads which
>> will be strongly affected by this modification. For instance, running
>> md5sum daily on the filesystem will cause a write for every file.
> 
> Yes. And? I can't think of a single case where something could 
> absolutely depend on the current relatime semantics, so altering them to 
> more usefully match the atime semantics doesn't seem likely to cause any 
> trouble.
Of course, by construction, there is nothing relying on the current
relatime semantics. The problem is that whenever you are making relatime
closer to the atime behaviour, you are also getting closer to the
original drawbacks of atime (one read generates one write).

> The use case in this case is the significant body of currently installed 
> machines that don't have /tmp on a separate filesystem. In the very 
> common setup of tmpreaper being used, the current relatime semantics 
> will result in undesired data loss. I think the proposed alteration 
> makes the behaviour of relatime massively more useful without any 
> obvious drawbacks.
Yes, it might bring important drawbacks: performance-wise, relatime will
become more like atime, making it much less useful. There is also a
significant number of desktop computers that are turned on once a day,
the boot time may get hindered by those additional writes.

Actually, you are changing relatime from a boolean condition (maximum
one additional write per write) to a atime with a coarse grain (maximum
one additional write per day). Today you found a use case that needs a
precision of one day. Tomorrow, someone else will find a use case that
needs a precision of one hour. So maybe what is actually needed is a
third option, a "grainatime" option where you can change the precision
of the atime.

Eric

--------------040607060101070202090902
Content-Type: text/x-vcard; charset=utf-8;
 name="E_A_B_Piel.vcf"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="E_A_B_Piel.vcf"

begin:vcard
fn;quoted-printable:=C3=89ric Piel
n;quoted-printable:Piel;=C3=89ric
org:Technical University of Delft;Software Engineering Research Group
adr:HB 08.080;;Mekelweg 4;Delft;;2628 CD;The Netherlands
email;internet:E.A.B.Piel@tudelft.nl
tel;work:+31 15 278 6338
tel;cell:+31 6 2437 9135
x-mozilla-html:FALSE
url:http://pieleric.free.fr
version:2.1
end:vcard


--------------040607060101070202090902--
