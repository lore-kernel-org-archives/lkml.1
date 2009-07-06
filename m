Return-Path: <linux-kernel-owner+w=401wt.eu-S1754526AbZGFXNz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754526AbZGFXNz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jul 2009 19:13:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753572AbZGFXNr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Jul 2009 19:13:47 -0400
Received: from mail-vw0-f202.google.com ([209.85.212.202]:59022 "EHLO
	mail-vw0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753828AbZGFXNq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jul 2009 19:13:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:date:x-google-sender-auth:message-id:subject
         :from:to:content-type:content-transfer-encoding;
        b=rFDL8031hjMke4cwhowwq0ccbNYNNetdlEJy5AnpfwvonAu30PvMVR1XcOwnHzlwT1
         P7tOtfeMTeRmdG1gYkPNPBbbaYLqDF1xUfmKZZ86tjjbHEzt4GEFIUmknqPk4AHGSKug
         FrmWNGYboEqz3TYXIrTc6AmhTUWG0ugipdIkM=
MIME-Version: 1.0
Date: Mon, 6 Jul 2009 16:13:48 -0700
X-Google-Sender-Auth: 70503b5a7b6857e6
Message-ID: <396556a20907061613h48691c80m75e5bfe17c1069cb@mail.gmail.com>
Subject: SCM_CREDENTIALS and PID namespaces
From: Adam Langley <agl@imperialviolet.org>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, the SCM_CREDENTIALS control message contains the PID of the
sending process, in the sender's PID namespace. This would seem to
violate the spirit of SCM_CREDENTIALS since, from the receiver's point
of view, the sender's PID in that namespace might be another process
entirely.

I started to write a patch for this, but then got hung up on the
semantics, so I'm asking here first.

Here's what I think should happen:

A received SCM_CREDENTIALS should contain the PID of the sending
process, in the receiver's namespace. Or -1 if the PID is not
representable.

If the sending process has exited, the pid should be -1. (We don't
want to hold a reference to a struct pid from the SKB, so we have to
do this).

When sending an SCM_CREDENTIALS message, if pid == getpid(), then the
PID acts as above. Otherwise, we pass the PID raw to the receiver.  (A
process has to be CAP_SYS_ADMIN to fake its PID).


Seem reasonable?


AGL

-- 
Adam Langley agl@imperialviolet.org http://www.imperialviolet.org
