Return-Path: <linux-kernel-owner+w=401wt.eu-S1760243AbXEYK5l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760243AbXEYK5l (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2007 06:57:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751507AbXEYK5e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 May 2007 06:57:34 -0400
Received: from an-out-0708.google.com ([209.85.132.248]:7916 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751324AbXEYK5d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2007 06:57:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=sW8SPvkkllxhyefahO/NQrp5VfFa2q6yOIyyYgj5PSNb2W/PFNbaz2801M76RlUgR8jHrIALHdXwtzRcRRMm6tjKEYmcxhI+iJoQSMm87RxBRI7JEoy7L+F1dwhC7L8VhLvPOda970QfrheheSjsPVvJvG2VBjhZv0Fp7KLUlXI=
Message-ID: <5a20704e0705250357j3b45e0dpb6d3d0d907af4da3@mail.gmail.com>
Date: Fri, 25 May 2007 06:57:33 -0400
From: "In Cognito" <defend.the.world@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: ptrace still broken- PTRACE_CONT trap flag, and debug state
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

main(){
__asm__("pushf\r\n"
               "popf\r\n"
              );
}

Single stepping through the "pushf" instruction and then attempting to
PTRACE_CONT will generate SIGTRAPs at each instruction. Although the
trap flag appears to not be set according to GETREG values, the pushf
will push a value with the TF bit on, which is then restored with
popf...

Here's an example of single stepping on a 2.6.8 and the trap flag
(uppercase letter means enabled):

8048351: push %ecx.
  eax=bffff7cc ebx=40146adc ecx=bffff740 edx=00000001
  esi=bffff7c4 edi=bffff750 ebp=bffff728 esp=bffff724
  flags= [c] [P] [a] [z] [S] [T] [I] [df] [id]

8048352: pushf .
  eax=bffff7cc ebx=40146adc ecx=bffff740 edx=00000001
  esi=bffff7c4 edi=bffff750 ebp=bffff728 esp=bffff720
  flags= [c] [P] [a] [z] [S] [T] [I] [df] [id]

8048353: popf .
  eax=bffff7cc ebx=40146adc ecx=bffff740 edx=00000001
  esi=bffff7c4 edi=bffff750 ebp=bffff728 esp=bffff724
  flags= [c] [P] [a] [z] [S] [T] [I] [df] [id]

8048354: pop %ecx.
  eax=bffff7cc ebx=40146adc ecx=bffff740 edx=00000001
  esi=bffff7c4 edi=bffff750 ebp=bffff728 esp=bffff728
  flags= [c] [P] [a] [z] [S] [T] [I] [df] [id]



and a 2.6.20



8048351: push %ecx.
  eax=bfcff654 ebx=b7f52ff4 ecx=bfcff5d0 edx=00000001
  esi=b7f80ce0 edi=00000000 ebp=bfcff5b8 esp=bfcff5b4
  flags= [c] [P] [a] [z] [S] [t] [I] [df] [id] 286

8048352: pushf .
  eax=bfcff654 ebx=b7f52ff4 ecx=bfcff5d0 edx=00000001
  esi=b7f80ce0 edi=00000000 ebp=bfcff5b8 esp=bfcff5b0
  flags= [c] [P] [a] [z] [S] [t] [I] [df] [id] 286

8048353: popf .
  eax=bfcff654 ebx=b7f52ff4 ecx=bfcff5d0 edx=00000001
  esi=b7f80ce0 edi=00000000 ebp=bfcff5b8 esp=bfcff5b4
  flags= [c] [P] [a] [z] [S] [T] [I] [df] [id] 386

8048354: pop %ecx.
  eax=bfcff654 ebx=b7f52ff4 ecx=bfcff5d0 edx=00000001
  esi=b7f80ce0 edi=00000000 ebp=bfcff5b8 esp=bfcff5b8
  flags= [c] [P] [a] [z] [S] [T] [I] [df] [id] 386



I'm not sure where along the line this was broken but it looks like
there were more than a few changes...
