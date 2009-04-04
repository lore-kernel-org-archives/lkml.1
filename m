Return-Path: <linux-kernel-owner+w=401wt.eu-S1756585AbZDDIEw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756585AbZDDIEw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Apr 2009 04:04:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752758AbZDDIEc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Apr 2009 04:04:32 -0400
Received: from mail-bw0-f169.google.com ([209.85.218.169]:45456 "EHLO
	mail-bw0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752728AbZDDIE3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Apr 2009 04:04:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=YZP7PKRB6+NEh9oBB6YBy/MELgnpGzUqq8DE8jcx3fn9689SFkJ5VJFYyn64I+OAcd
         KHwiyaIuEfkVcJx1aSE/O/4UCvLIOyueTTPhfTPs6e/xRzRgaSaNe9NK18iPjj4/7pxE
         Uu2zfjcSDAiRXnIVnfWEWenmFHO9xreitaHrw=
MIME-Version: 1.0
In-Reply-To: <49D4F2E1.7000507@vlnb.net>
References: <49D10256.8030307@vlnb.net>
	 <e2e108260904011314h1e0cf5c5wcdf210eee24d40d8@mail.gmail.com>
	 <49D4F2E1.7000507@vlnb.net>
Date: Sat, 4 Apr 2009 10:04:26 +0200
Message-ID: <e2e108260904040104u37953ef7x74b8713dfcf3166a@mail.gmail.com>
Subject: Re: [Scst-devel] ISCSI-SCST performance (with also IET and STGT data)
From: Bart Van Assche <bart.vanassche@gmail.com>
To: Vladislav Bolkhovitin <vst@vlnb.net>
Cc: scst-devel <scst-devel@lists.sourceforge.net>,
       linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 2, 2009 at 7:16 PM, Vladislav Bolkhovitin <vst@vlnb.net> wrote:
> Bart Van Assche, on 04/02/2009 12:14 AM wrote:
>> I have repeated some of these performance tests for iSCSI over IPoIB
>> (two DDR PCIe 1.0 ConnectX HCA's connected back to back). The results
>> for the buffered I/O test with a block size of 512K (initiator)
>> against a file of 1GB residing on a tmpfs filesystem on the target are
>> as follows:
>>
>> write-test: iSCSI-SCST 243 MB/s; IET 192 MB/s.
>> read-test: iSCSI-SCST 291 MB/s; IET 223 MB/s.
>>
>> And for a block size of 4 KB:
>>
>> write-test: iSCSI-SCST 43 MB/s; IET 42 MB/s.
>> read-test: iSCSI-SCST 288 MB/s; IET 221 MB/s.
>
> Do you have any thoughts why writes are so bad? It shouldn't be so..

By this time I have run the following variation of the 4 KB write test:
* Target: iSCSI-SCST was exporting a 1 GB file residing on a tmpfs filesystem.
* Initiator: two processes were writing 4 KB blocks as follows:
dd if=/dev/zero of=/dev/sdb bs=4K seek=0 count=131072 oflag=sync &
dd if=/dev/zero of=/dev/sdb bs=4K seek=131072 count=131072 oflag=sync &

Results:
* Each dd process on the initiator was writing at a speed of 37.8
MB/s, or a combined writing speed of 75.6 MB/s.
* CPU load on the initiator system during the test: 2.0.
* According to /proc/interrupts, about 38000 mlx4-comp-0 interrupts
were triggered per second.

These results confirm that the initiator system was the bottleneck
during the 4 KB write test, not the target system.

Bart.
