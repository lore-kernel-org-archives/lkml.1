Return-Path: <linux-kernel-owner+w=401wt.eu-S1751956AbZAXGuU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751956AbZAXGuU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Jan 2009 01:50:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750846AbZAXGuG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 Jan 2009 01:50:06 -0500
Received: from wa-out-1112.google.com ([209.85.146.179]:33557 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750830AbZAXGuE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Jan 2009 01:50:04 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=XD9PgWXR6+oA0bTEtVnggbxJcMTp2stDtJdiaZ1RucFw6e7ucfofR6473YLZW34PE+
         121bD2zxyhGgtvHduFOVyeBcTRzi28XG8JNmM7cB5f941hbv9noJtRLy8fod4tYTnKv6
         r2StA39v67qpciVs5akAHwCKyaaJWFaDZK+dw=
MIME-Version: 1.0
In-Reply-To: <s5h7i4psepm.wl%tiwai@suse.de>
References: <1232465902.3088.31.camel@localhost.localdomain>
	 <s5h7i4psepm.wl%tiwai@suse.de>
Date: Sat, 24 Jan 2009 12:20:03 +0530
Message-ID: <3f9a31f40901232250i27a673a9r8b0620f968e351e1@mail.gmail.com>
Subject: Re: usr/include/linux/soundcard.h warnings for 'make headers_check'
From: Jaswinder Singh Rajput <jaswinderlinux@gmail.com>
To: Takashi Iwai <tiwai@suse.de>
Cc: Jaswinder Singh Rajput <jaswinder@kernel.org>, alsa-devel@alsa-project.org,
       Sam Ravnborg <sam@ravnborg.org>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 21, 2009 at 5:38 AM, Takashi Iwai <tiwai@suse.de> wrote:
> At Tue, 20 Jan 2009 21:08:22 +0530,
> Jaswinder Singh Rajput wrote:
>>
>> usr/include/linux/soundcard.h is giving following warnings for 'make headers_check':
>>  usr/include/linux/soundcard.h:1047: extern's make no sense in userspace
>>  usr/include/linux/soundcard.h:1048: extern's make no sense in userspace
>>  usr/include/linux/soundcard.h:1049: extern's make no sense in userspace
>>  usr/include/linux/soundcard.h:1050: extern's make no sense in userspace
>>  usr/include/linux/soundcard.h:1051: extern's make no sense in userspace
>>  usr/include/linux/soundcard.h:1053: extern's make no sense in userspace
>>  usr/include/linux/soundcard.h:1055: extern's make no sense in userspace
>>  usr/include/linux/soundcard.h:1056: extern's make no sense in userspace
>>  usr/include/linux/soundcard.h:1061: extern's make no sense in userspace
>>  usr/include/linux/soundcard.h:1062: extern's make no sense in userspace
>>  usr/include/linux/soundcard.h:1078: extern's make no sense in userspace
>>  usr/include/linux/soundcard.h:1079: extern's make no sense in userspace
>>
>> Do we need to fix these warnings.
>
> No, these are declarations for OSS-lib.
> It doesn't belong to kernel, but it's better to keep it for
> compatibility in some way.
>

Do you find some better place for:

void seqbuf_dump(void); /* This function must be provided by programs */

extern int OSS_init(int seqfd, int buflen);
extern void OSS_seqbuf_dump(int fd, unsigned char *buf, int buflen);
extern void OSS_seq_advbuf(int len, int fd, unsigned char *buf, int buflen);
extern void OSS_seq_needbuf(int len, int fd, unsigned char *buf, int buflen);
extern void OSS_patch_caching(int dev, int chn, int patch,
                              int fd, unsigned char *buf, int buflen);
extern void OSS_drum_caching(int dev, int chn, int patch,
                              int fd, unsigned char *buf, int buflen);
extern void OSS_write_patch(int fd, unsigned char *buf, int len);
extern int OSS_write_patch2(int fd, unsigned char *buf, int len);
..

#ifdef OSSLIB
#  define SEQ_USE_EXTBUF() \
                extern unsigned char *_seqbuf; \
                extern int _seqbuflen;extern int _seqbufptr
#  define SEQ_DEFINEBUF(len) SEQ_USE_EXTBUF();static int
_requested_seqbuflen=len
#  define _SEQ_ADVBUF(len) OSS_seq_advbuf(len, seqfd, _seqbuf, _seqbuflen)
#  define _SEQ_NEEDBUF(len) OSS_seq_needbuf(len, seqfd, _seqbuf, _seqbuflen)
#  define SEQ_DUMPBUF() OSS_seqbuf_dump(seqfd, _seqbuf, _seqbuflen)

#  define SEQ_LOAD_GMINSTR(dev, instr) \
                OSS_patch_caching(dev, -1, instr, seqfd, _seqbuf, _seqbuflen)
#  define SEQ_LOAD_GMDRUM(dev, drum) \
                OSS_drum_caching(dev, -1, drum, seqfd, _seqbuf, _seqbuflen)
#else /* !OSSLIB */

#  define SEQ_LOAD_GMINSTR(dev, instr)
#  define SEQ_LOAD_GMDRUM(dev, drum)

#  define SEQ_USE_EXTBUF() \
                extern unsigned char _seqbuf[]; \
                extern int _seqbuflen;extern int _seqbufptr

..

what are your plans.

--
JSR
