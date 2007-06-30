Return-Path: <linux-kernel-owner+w=401wt.eu-S1752830AbXF3BsX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752830AbXF3BsX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2007 21:48:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751607AbXF3BsN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jun 2007 21:48:13 -0400
Received: from wx-out-0506.google.com ([66.249.82.230]:64983 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751599AbXF3BsM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2007 21:48:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=rJVAb9awayyyS1yy4M8BvLdC+uojpjjjxpQ7qmeq95TgT5YIFE7tRhwLX+d2Hkse2dphehdZiJMM9GwAvNtH+0yptbsowLk4Flli2YydWCX5aHxmUWFVPZiaAz2kcCXMQJi9I5mSanrX/KraYTqqi8jLqpJJETQ0D9a1XyNel7M=
Message-ID: <a36005b50706291848p406fbb9aw99697f609b0d5c4b@mail.gmail.com>
Date: Fri, 29 Jun 2007 18:48:07 -0700
From: "Ulrich Drepper" <drepper@gmail.com>
To: "Davide Libenzi" <davidel@xmailserver.org>
Subject: Re: [patch 0/6] sys_indirect RFC - sys_indirect introduction
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Ingo Molnar" <mingo@elte.hu>
In-Reply-To: <send-serie.davidel@xmailserver.org.28360.1183153732.0>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <send-serie.davidel@xmailserver.org.28360.1183153732.0>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/29/07, Davide Libenzi <davidel@xmailserver.org> wrote:
> [include/linux/indirect.h]
>         #define SYSIND_CTX_OPENFLAGS    0
>         struct sysind_ctx_OPENFLAGS {
>                 __u32 ctx;
>                 __u32 flags;

I agree that this interface is more than any other in danger of
needing an interface change.  But I think your solution is a bit too
expensive and complex.  You need two reads from userlevel.

The standard way to handle this is a versioned struct.  I.e., define a
struct for the current needs, define an initial version.  To use the
syscall pass the version number and the struct pointer to the syscall.
 If the kernel doesn't know the version number it fails.  Otherwise it
might have to read old versions of the struct which is trivial to do.
E.g.:

#define SYSIND_VERSION 1
#define SYSIND_CTX_OPENFLAGS 0
#define SYSIND_CTX_SIGMASK 1
struct sysind_ctx {
  int ctx;
  union {
    int flags;
    kernel_sigset_t  sset;
  };
};

long sys_indirect(unsigned int nr,
                       int ctx_version,
                       const struct indirect_ctx *ctx,
                       const unsigned long *params);


This reduces the number of accesses to userlevel data to one and still
has all the flexibility needed.
