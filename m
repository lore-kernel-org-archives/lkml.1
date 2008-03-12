Return-Path: <linux-kernel-owner+w=401wt.eu-S1752827AbYCLQaI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752827AbYCLQaI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2008 12:30:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751381AbYCLQ37
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Mar 2008 12:29:59 -0400
Received: from wx-out-0506.google.com ([66.249.82.232]:4638 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751261AbYCLQ36 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2008 12:29:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=rZt5RqF/rHTKGdzO+JsS/ttlu9Wk/0UND3Xwi86ndA/+EFfR22OKB0H0B1eqoHWAxt7o+2Z+QBksFJPMTurAjW8GkzG65OOF/voArvNKexRTuXoSfsCP85T/jLEOSYnE807inHSB+LgFQ1GywxkeAp0/zMN1rIh93YVckqO8atE=
Message-ID: <19f34abd0803120929j19a043bq711e8a374edbdfe8@mail.gmail.com>
Date: Wed, 12 Mar 2008 17:29:54 +0100
From: "Vegard Nossum" <vegard.nossum@gmail.com>
To: "Frank Munzert" <frankm@linux.vnet.ibm.com>
Subject: Re: BUG: lock held when returning to user space
Cc: mingo@elte.hu, linux-kernel@vger.kernel.org
In-Reply-To: <47D7FAA0.1090802@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <47D7FAA0.1090802@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 12, 2008 at 4:45 PM, Frank Munzert
<frankm@linux.vnet.ibm.com> wrote:
>  we provided a device driver vmur dealing with z/VM virtual unit record
>  devices (reader, punch, printer). A corresponding user space tool
>  provides functions similar to the CMS commands RECEIVE, PUNCH, PRINT.
>  Unit record devices are not meant for concurrent read or write by
>  multiple users, that's why we need to serialize access. The driver's
>  open method uses  mutex_trylock or  mutex_lock_interruptible  to  ensure
>  exclusive access to the device, while its  release method  uses
>  mutex_unlock.

snip.

>  For the vmur device driver it is crucial to have only one process access
>  a given unit record device node at a given time. So having open hold the
>  mutex and return to user space is exactly what we want. Is  there any
>  annotation  to tell lockdep to suppress or bypass this kind of warning?

This sounds like a serious abuse of mutexes.

Wouldn't it be correct to use the mutex to protect a separate variable
(which indicates whether the device has been open()ed) and nothing
else? Then there is no need to hold the mutex across the syscalls and
open() can simply fail if the separate variable is set.


Kind regards,
Vegard Nossum
