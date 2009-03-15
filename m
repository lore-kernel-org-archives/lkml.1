Return-Path: <linux-kernel-owner+w=401wt.eu-S1759072AbZCOKrX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759072AbZCOKrX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Mar 2009 06:47:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756713AbZCOKrO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Mar 2009 06:47:14 -0400
Received: from mail-fx0-f176.google.com ([209.85.220.176]:59478 "EHLO
	mail-fx0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755400AbZCOKrN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Mar 2009 06:47:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type:content-transfer-encoding;
        b=JC1+zTTY3w0zp4nbK09NyexGL31MfaUBLrPFRP7CeQT+xH0HpQmKYCSXsvUI/ieglW
         ijKn0WF7lRc0+WcgjUaoH3Et+B57NoTCpQ7EDXNbOrDHRUNOuV8rNNkmJt2kv9BVqcae
         /4oNKZCuHCLr8LN3pJBB3GqxDx62/QpWIsb+o=
Message-ID: <49BCDCAA.8040309@gmail.com>
Date: Sun, 15 Mar 2009 11:47:06 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090223 SUSE/3.0b2-3.1 Thunderbird/3.0b2
MIME-Version: 1.0
To: Len Brown <lenb@kernel.org>
CC: linux-acpi@vger.kernel.org, rjw@sisk.pl,
       Linux kernel mailing list <linux-kernel@vger.kernel.org>,
       torvalds@linux-foundation.org
Subject: 2.6.29 acpi regression: acpi_ex_extract_from_field -- div by zero
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

sometimes, when booting up/resuming from disk, I get an oops[1].

obj_desc->common_field.access_bit_width is zero, but even after the 
loop. Division before the loop is apparently OK.

This is the case:
         /* Mask off any extra bits in the last datum */

         buffer_tail_bits = obj_desc->common_field.bit_length %
             obj_desc->common_field.access_bit_width;

.L39:
         xorl    %edx, %edx      #
         movzbl  37(%rbx), %esi  # 
<variable>.common_field.access_bit_width, 
<variable>.common_field.access_bit_width
         movl    24(%rbx), %eax  # <variable>.common_field.bit_length, 
<variable>.common_field.bit_length
--------------- here:
         divl    %esi    # <variable>.common_field.access_bit_width
         movl    %edx, %ecx      #, tmp121
         testl   %edx, %edx      # tmp121
         je      .L41    #,

[1] http://www.fi.muni.cz/~xslaby/sklad/panics/acpi_oops.png
