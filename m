Return-Path: <linux-kernel-owner+w=401wt.eu-S1758141AbYFBIyF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758141AbYFBIyF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2008 04:54:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751322AbYFBIxx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jun 2008 04:53:53 -0400
Received: from mtagate1.de.ibm.com ([195.212.29.150]:37807 "EHLO
	mtagate1.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752807AbYFBIxw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2008 04:53:52 -0400
From: Christian Borntraeger <borntraeger@de.ibm.com>
To: akinobu.mita@gmail.com
Subject: Re: [patch -v2 06/23] s390/vmcp: use simple_read_from_buffer
Date: Mon, 2 Jun 2008 10:53:34 +0200
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Heiko Carstens <heiko.carstens@de.ibm.com>, linux390@de.ibm.com,
       linux-s390@vger.kernel.org
References: <20080601231329.223608711@gmail.com> <20080601231515.779423991@gmail.com>
In-Reply-To: <20080601231515.779423991@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806021053.34647.borntraeger@de.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Montag, 2. Juni 2008 schrieb akinobu.mita@gmail.com:

> -	tocopy = min(session->resp_size - (size_t) (*ppos), count);
> -	tocopy = min(tocopy, session->bufsize - (size_t) (*ppos));
> +	ret = simple_read_from_buffer(buff, count, ppos,
> +				session->response, session->resp_size);
> 

Its not that simple. The z/VM Diagnose 8 has a quite interesting return value.

- session->bufsize is the size of the buffer as we allocated and know 
- session->resp_size is the size of the data - no matter if the buffer was 
large enough. z/VM is smart enough to not go beyond the buffer, but it tells 
us how many bytes it skipped. resp_size contains bufsize + skipped_bytes.

Unfortunately there is no end of string delimiter and we have to use the 
response size.

There are two cases:
1. The buffer was large enough, so we can use session->resp_size
2. The buffer was not large enough and output was truncated. we must now use 
session->bufsize

Christian
