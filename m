Return-Path: <linux-kernel-owner+w=401wt.eu-S1753774AbZKIUqT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753774AbZKIUqT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Nov 2009 15:46:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751326AbZKIUqS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Nov 2009 15:46:18 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58886 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751046AbZKIUqR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Nov 2009 15:46:17 -0500
Date: Mon, 9 Nov 2009 12:46:18 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Helge Deller <deller@gmx.de>
Cc: linux-kernel@vger.kernel.org, Anton Blanchard <anton@samba.org>,
       Paul Mackerras <paulus@samba.org>
Subject: Re: [PATCH] Implement prctl(PR_GET_ENDIAN) for all architectures
Message-Id: <20091109124618.2aa98630.akpm@linux-foundation.org>
In-Reply-To: <20091022193533.GA5827@p100.box>
References: <20091022193533.GA5827@p100.box>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 22 Oct 2009 21:35:33 +0200
Helge Deller <deller@gmx.de> wrote:

> The PR_GET_ENDIAN and PR_SET_ENDIAN prctl() calls have been implemented
> to allow to switch processes at runtime from big-endian to little-endian
> mode (and vice versa) on PowerPC processors. Since the other architectures
> don't support this feature, they currently will just fail and return -EINVAL.
> 
> This patch adds just minimal overhead and implements the PR_GET_ENDIAN
> call for all other architectures by returning the native endianess of
> the architecture. Furthermore, calling prctl(PR_SET_ENDIAN) with the
> native endianess of the architecture will succeed, while trying to
> set another (not-supported) endianess, will fail.
> 
> The patch can be tested with the following program:
> 
> #include <stdio.h>
> #include <linux/prctl.h>
> 
> int main(int argc, char **argv)
> {
> 	int endian, ret;
> 
> 	ret = prctl(PR_GET_ENDIAN, &endian);
> 	if (ret)
> 		perror("prctl(PR_GET_ENDIAN) not implemented");
> 	printf("current process/machine is running in %s endian mode (%d)\n",
> 		endian == PR_ENDIAN_LITTLE ? "little":"big", endian);
> 
> 	/* setting native endianess should succeed */
> 	ret = prctl(PR_SET_ENDIAN, endian);
> 	printf("prctl(PR_SET_ENDIAN,%d) should succeed: %s\n",
> 		endian, ret == 0 ? "OK":"FAIL");
> 
> 	/* setting foreign endianess should fail */
> 	endian = (endian == PR_ENDIAN_LITTLE) ?
> 		PR_ENDIAN_BIG : PR_ENDIAN_LITTLE;
> 	ret = prctl(PR_SET_ENDIAN, endian);
> 	printf("prctl(PR_SET_ENDIAN,%d) should fail: %s\n",
> 		endian, ret == 0 ? "OK":"FAIL");
> }
> 

The changelog forgot to provide any reason for making this change to
the kernel.

