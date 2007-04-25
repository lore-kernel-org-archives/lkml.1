Return-Path: <linux-kernel-owner+w=401wt.eu-S1752987AbXDYJaR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752987AbXDYJaR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2007 05:30:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753885AbXDYJaQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Apr 2007 05:30:16 -0400
Received: from pfx2.jmh.fr ([194.153.89.55]:42882 "EHLO pfx2.jmh.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752987AbXDYJaN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2007 05:30:13 -0400
Date: Wed, 25 Apr 2007 11:30:05 +0200
From: Eric Dumazet <dada1@cosmosbay.com>
To: Jakub Jelinek <jakub@redhat.com>
Cc: Jan Engelhardt <jengelh@linux01.gwdg.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Big reserved mappings on x86_64
Message-Id: <20070425113005.21bccfab.dada1@cosmosbay.com>
In-Reply-To: <20070425084931.GC355@devserv.devel.redhat.com>
References: <Pine.LNX.4.61.0704251035480.19711@yvahk01.tjqt.qr>
	<20070425084931.GC355@devserv.devel.redhat.com>
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.10.11; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 25 Apr 2007 04:49:31 -0400
Jakub Jelinek <jakub@redhat.com> wrote:

> On Wed, Apr 25, 2007 at 10:42:20AM +0200, Jan Engelhardt wrote:
> > I actually took a look at `pmap $$`, which reveals that a lot of shared 
> > libraries map 2044K or 2048K unreadable-unwritable-private 
> > mappings...for _what_ purpose?
> > 
> > 10:37 opteron:~ > pmap $$
> > 4403: bash
> > START       SIZE     RSS   DIRTY PERM MAPPING
> > 2ae6cca70000    212K    172K      0K r-xp /lib64/libreadline.so.5.2
> > 2ae6ccaa5000   2044K      0K      0K ---p /lib64/libreadline.so.5.2 <--
> > 2ae6ccca4000      4K      4K      4K r--p /lib64/libreadline.so.5.2
> > 2ae6ccca5000     28K     28K     28K rw-p /lib64/libreadline.so.5.2
> > 2ae6cccac000      8K      8K      8K rw-p [anon]
> > 2ae6cccae000     28K     16K      0K r-xp /lib64/libhistory.so.5.2
> > 2ae6cccb5000   2048K      0K      0K ---p /lib64/libhistory.so.5.2 <--
> > 2ae6cceb5000      8K      8K      8K rw-p /lib64/libhistory.so.5.2
> > 2ae6cceb7000    320K    208K      0K r-xp /lib64/libncurses.so.5.5
> > 2ae6ccf07000   2048K      0K      0K ---p /lib64/libncurses.so.5.5 <--
> > 2ae6cd107000     48K     48K     48K r--p /lib64/libncurses.so.5.5
> > 2ae6cd113000     28K     28K     28K rw-p /lib64/libncurses.so.5.5
> > [...]
> > 
> > What could these ominous mappings be? Does anyone else see that - 
> > perhaps someone with x86_64 && !(opensuse 10.2)?
> 
> While i386 only supports 4KB pages, x86_64 ELF objects ought to support
> up to 2MB pages.  The gap between read-only/executable and writable segments
> is intentionally mapped PROT_NONE, so that other things aren't mapped in
> between the segments.
>


This makes sense for catching some programming errors, but it also has a cost for innocent users, since it adds one vm_area_struct per dll.

It slows down all find_vma() operations that tend to be done quite frequently these days :(

Even with a rbtree, adding 150 vm_area_struct increase memory needs and cache misses.

Maybe these PROT_NONE mappings could be done iff some LD_DEBUG or other ld.so variable says so ?

BTW I dont see such mappings on my 32bit distro (Ubuntu 7.04, glibc-2.5)

$ pmap 6791|grep .so
aa566000   2036K r-x--  /home/edumazet/.mozilla/plugins/libflashplayer.so
aa763000     64K rw---  /home/edumazet/.mozilla/plugins/libflashplayer.so
b07da000    220K r-x--  /usr/lib/firefox/libnssckbi.so
b0811000     36K rw---  /usr/lib/firefox/libnssckbi.so
b081a000    252K r-x--  /usr/lib/libfreebl3.so
b0859000      4K rw---  /usr/lib/libfreebl3.so
b105b000    300K r-x--  /usr/lib/libsoftokn3.so
b10a6000     16K rw---  /usr/lib/libsoftokn3.so
b10aa000    436K r-x--  /usr/lib/libnss3.so
b1117000     20K rw---  /usr/lib/libnss3.so
b111c000    160K r-x--  /usr/lib/libssl3.so
b1144000      8K rw---  /usr/lib/libssl3.so
b1146000    136K r-x--  /usr/lib/libsmime3.so
b1168000      8K rw---  /usr/lib/libsmime3.so
b116a000    364K r-x--  /usr/lib/firefox/components/libpipnss.so
b11c5000     16K rw---  /usr/lib/firefox/components/libpipnss.so
b1212000      8K r-x--  /lib/libnss_mdns4_minimal.so.2
b1214000      4K rw---  /lib/libnss_mdns4_minimal.so.2
b122f000    204K r-x--  /usr/lib/firefox/components/libmork.so
b1262000     12K rw---  /usr/lib/firefox/components/libmork.so
b2a68000    348K r-x--  /usr/lib/firefox/components/libstoragecomps.so
b2abf000      8K rw---  /usr/lib/firefox/components/libstoragecomps.so
b2c14000    364K r-x--  /usr/lib/libbonoboui-2.so.0.0.0
b2c6f000     12K rw---  /usr/lib/libbonoboui-2.so.0.0.0
b2c72000    552K r-x--  /usr/lib/libgnomeui-2.so.0.1788.4
b2cfc000     16K rw---  /usr/lib/libgnomeui-2.so.0.1788.4
b2e04000     48K r-x--  /usr/lib/libgnome-keyring.so.0.0.1
b2e10000      4K rw---  /usr/lib/libgnome-keyring.so.0.0.1
b2e11000     80K r-x--  /usr/lib/libart_lgpl_2.so.2.3.17
b2e25000      4K rw---  /usr/lib/libart_lgpl_2.so.2.3.17
b2e26000    164K r-x--  /usr/lib/libgnomecanvas-2.so.0.1400.0
b2e4f000      4K rw---  /usr/lib/libgnomecanvas-2.so.0.1400.0
b2e54000     16K r-x--  /lib/tls/i686/cmov/libnss_dns-2.5.so
b2e58000      8K rw---  /lib/tls/i686/cmov/libnss_dns-2.5.so
b2e5a000     16K r-x--  /usr/lib/firefox/components/libmozgnome.so
b2e5e000      4K rw---  /usr/lib/firefox/components/libmozgnome.so
b2e5f000     40K r-x--  /usr/lib/firefox/components/libnecko2.so
b2e69000      4K rw---  /usr/lib/firefox/components/libnecko2.so
b2e6a000     28K r-x--  /usr/lib/firefox/components/libimgicon.so
b2e71000      4K rw---  /usr/lib/firefox/components/libimgicon.so
b2e72000     76K r-x--  /usr/lib/firefox/components/libcomposer.so
b2e85000      8K rw---  /usr/lib/firefox/components/libcomposer.so
b2e87000     64K r-x--  /usr/lib/firefox/components/libspellchecker.so
b2e97000      4K rw---  /usr/lib/firefox/components/libspellchecker.so
b2e98000     20K r-x--  /usr/lib/firefox/components/libtxmgr.so
b2e9d000      4K rw---  /usr/lib/firefox/components/libtxmgr.so
b2e9e000    616K r-x--  /usr/lib/firefox/components/libeditor.so
b2f38000     16K rw---  /usr/lib/firefox/components/libeditor.so
b34b8000     84K r-x--  /usr/lib/libXmu.so.6.2.0
b34cd000      4K rw---  /usr/lib/libXmu.so.6.2.0
b35b3000     16K r-x--  /usr/lib/gtk-2.0/2.10.0/loaders/libpixbufloader-png.so
b35b7000      4K rw---  /usr/lib/gtk-2.0/2.10.0/loaders/libpixbufloader-png.so
b35bd000    236K r-x--  /home/edumazet/Desktop/jre1.5.0_07/lib/i386/libjavaplugin_nscp.so
b35f8000     28K rw---  /home/edumazet/Desktop/jre1.5.0_07/lib/i386/libjavaplugin_nscp.so
b35ff000    116K r-x--  /home/edumazet/Desktop/jre1.5.0_07/plugin/i386/ns7/libjavaplugin_oji.so
b361c000     20K rw---  /home/edumazet/Desktop/jre1.5.0_07/plugin/i386/ns7/libjavaplugin_oji.so
b3621000     68K r-x--  /usr/lib/totem/libtotem-narrowspace-plugin.so
b3632000      4K rw---  /usr/lib/totem/libtotem-narrowspace-plugin.so
b36ac000     44K r-x--  /usr/lib/totem/libtotem-mully-plugin.so
b36b7000      4K rw---  /usr/lib/totem/libtotem-mully-plugin.so
b36b8000     76K r-x--  /usr/lib/totem/libtotem-gmp-plugin.so
b36cb000      4K rw---  /usr/lib/totem/libtotem-gmp-plugin.so
b36cc000     28K r-x--  /usr/lib/libfam.so.0.0.0
b36d3000      4K rw---  /usr/lib/libfam.so.0.0.0
b36d4000     24K r-x--  /lib/libacl.so.1.1.0
b36da000      4K rw---  /lib/libacl.so.1.1.0
b36db000     12K r-x--  /lib/libattr.so.1.1.0
b36de000      4K rw---  /lib/libattr.so.1.1.0
b36e2000     44K r-x--  /usr/lib/totem/libtotem-basic-plugin.so
b36ed000      4K rw---  /usr/lib/totem/libtotem-basic-plugin.so
b36f9000     48K r-x--  /usr/lib/gnome-vfs-2.0/modules/libfile.so
b3705000      4K rw---  /usr/lib/gnome-vfs-2.0/modules/libfile.so
b3706000     20K r-x--  /usr/lib/firefox/components/libnkgnomevfs.so
b370b000      4K rw---  /usr/lib/firefox/components/libnkgnomevfs.so
b3710000      8K r-x--  /usr/lib/firefox/plugins/libunixprintplugin.so
b3712000      4K rw---  /usr/lib/firefox/plugins/libunixprintplugin.so
b3713000    164K r-x--  /usr/lib/firefox/components/libgkplugin.so
b373c000      8K rw---  /usr/lib/firefox/components/libgkplugin.so
b4826000    356K r-x--  /usr/lib/firefox/components/libhtmlpars.so
b487f000     32K rw---  /usr/lib/firefox/components/libhtmlpars.so
b4887000    756K r-x--  /usr/lib/firefox/components/libuconv.so
b4944000     28K rw---  /usr/lib/firefox/components/libuconv.so
b4955000     88K r-x--  /usr/lib/firefox/libjsj.so
b496b000      4K rw---  /usr/lib/firefox/libjsj.so
b496c000     80K r-x--  /usr/lib/firefox/components/liboji.so
b4980000      4K rw---  /usr/lib/firefox/components/liboji.so
b4981000     28K r-x--  /usr/lib/firefox/components/libpipboot.so
b4988000      4K rw---  /usr/lib/firefox/components/libpipboot.so
b518a000     72K r-x--  /usr/lib/firefox/components/libwebbrwsr.so
b519c000      8K rw---  /usr/lib/firefox/components/libwebbrwsr.so
b519e000    216K r-x--  /lib/libsepol.so.1
b51d4000      4K rw---  /lib/libsepol.so.1
b51df000     12K r-x--  /usr/lib/libgpg-error.so.0.3.0
b51e2000      4K rw---  /usr/lib/libgpg-error.so.0.3.0
b51e3000    316K r-x--  /usr/lib/libgcrypt.so.11.2.2
b5232000      8K rw---  /usr/lib/libgcrypt.so.11.2.2
b5234000     80K r-x--  /usr/lib/libtasn1.so.3.0.6
b5248000      4K rw---  /usr/lib/libtasn1.so.3.0.6
b5249000    768K r-x--  /usr/lib/libasound.so.2.0.0
b5309000     20K rw---  /usr/lib/libasound.so.2.0.0
b530e000     16K r-x--  /usr/lib/libORBitCosNaming-2.so.0.1.0
b5312000      4K rw---  /usr/lib/libORBitCosNaming-2.so.0.1.0
b5313000      8K r-x--  /lib/tls/i686/cmov/libutil-2.5.so
b5315000      8K rw---  /lib/tls/i686/cmov/libutil-2.5.so
b5317000     80K r-x--  /lib/libselinux.so.1
b532b000      8K rw---  /lib/libselinux.so.1
b532d000     60K r-x--  /lib/tls/i686/cmov/libresolv-2.5.so
b533c000      8K rw---  /lib/tls/i686/cmov/libresolv-2.5.so
b5340000     56K r-x--  /usr/lib/libavahi-client.so.3.2.2
b534e000      4K rw---  /usr/lib/libavahi-client.so.3.2.2
b534f000     40K r-x--  /usr/lib/libavahi-common.so.3.4.3
b5359000      4K rw---  /usr/lib/libavahi-common.so.3.4.3
b535a000    424K r-x--  /usr/lib/libgnutls.so.13.0.9
b53c4000     24K rw---  /usr/lib/libgnutls.so.13.0.9
b53ca000    196K r-x--  /usr/lib/libdbus-1.so.3.2.0
b53fb000      4K rw---  /usr/lib/libdbus-1.so.3.2.0
b53fc000    104K r-x--  /usr/lib/libdbus-glib-1.so.2.1.0
b5416000      4K rw---  /usr/lib/libdbus-glib-1.so.2.1.0
b5417000   1116K r-x--  /usr/lib/libxml2.so.2.6.27
b552e000     24K rw---  /usr/lib/libxml2.so.2.6.27
b5534000     28K r-x--  /lib/libpopt.so.0.0.0
b553b000      4K rw---  /lib/libpopt.so.0.0.0
b553c000    128K r-x--  /usr/lib/libaudiofile.so.0.0.2
b555c000      8K rw---  /usr/lib/libaudiofile.so.0.0.2
b555e000     36K r-x--  /usr/lib/libesd.so.0.2.36
b5567000      4K rw---  /usr/lib/libesd.so.0.2.36
b5568000     76K r-x--  /usr/lib/libbonobo-activation.so.4.0.0
b557b000      8K rw---  /usr/lib/libbonobo-activation.so.4.0.0
b557d000    328K r-x--  /usr/lib/libbonobo-2.so.0.0.0
b55cf000     40K rw---  /usr/lib/libbonobo-2.so.0.0.0
b55d9000    344K r-x--  /usr/lib/libgnomevfs-2.so.0.1800.1
b562f000     12K rw---  /usr/lib/libgnomevfs-2.so.0.1800.1
b5632000     80K r-x--  /usr/lib/libgnome-2.so.0.1800.0
b5646000      4K rw---  /usr/lib/libgnome-2.so.0.1800.0
b56a7000     68K r-x--  /usr/lib/libXft.so.2.1.2
b56b8000      4K rw---  /usr/lib/libXft.so.2.1.2
b56ba000     12K r-x--  /usr/lib/firefox/components/libremoteservice.so
b56bd000      4K rw---  /usr/lib/firefox/components/libremoteservice.so
b56be000     32K r-x--  /usr/lib/firefox/components/libcookie.so
b56c6000      4K rw---  /usr/lib/firefox/components/libcookie.so
b56c7000     12K r-x--  /usr/lib/firefox/components/libpermissions.so
b56ca000      4K rw---  /usr/lib/firefox/components/libpermissions.so
b56d3000    228K r-x--  /usr/lib/firefox/components/libgfx_gtk.so
b570c000     12K rw---  /usr/lib/firefox/components/libgfx_gtk.so
b570f000    120K r-x--  /usr/lib/libjpeg.so.62.0.0
b572d000      4K rw---  /usr/lib/libjpeg.so.62.0.0
b572f000      8K r-x--  /usr/lib/libavahi-glib.so.1.0.1
b5731000      4K rw---  /usr/lib/libavahi-glib.so.1.0.1
b5732000     24K r-x--  /usr/lib/gtk-2.0/2.10.0/loaders/libpixbufloader-xpm.so
b5738000      4K rw---  /usr/lib/gtk-2.0/2.10.0/loaders/libpixbufloader-xpm.so
b5739000      8K r-x--  /usr/lib/firefox/libgfxpsshar.so
b573b000      4K rw---  /usr/lib/firefox/libgfxpsshar.so
b573c000     24K r-x--  /usr/lib/libpangoxft-1.0.so.0.1600.2
b5742000      4K rw---  /usr/lib/libpangoxft-1.0.so.0.1600.2
b5743000     16K r-x--  /usr/lib/firefox/components/libcommandlines.so
b5747000      4K rw---  /usr/lib/firefox/components/libcommandlines.so
b5748000   5376K r-x--  /usr/lib/firefox/components/libgklayout.so
b5c88000    384K rw---  /usr/lib/firefox/components/libgklayout.so
b5cef000     28K r-x--  /lib/tls/i686/cmov/librt-2.5.so
b5cf6000      8K rw---  /lib/tls/i686/cmov/librt-2.5.so
b5cf8000     16K r-x--  /usr/lib/libgthread-2.0.so.0.1200.11
b5cfc000      4K rw---  /usr/lib/libgthread-2.0.so.0.1200.11
b5cfd000    292K r-x--  /usr/lib/libORBit-2.so.0.1.0
b5d46000     40K rw---  /usr/lib/libORBit-2.so.0.1.0
b5d50000    188K r-x--  /usr/lib/libgconf-2.so.4.1.2
b5d7f000     12K rw---  /usr/lib/libgconf-2.so.4.1.2
b5d82000     96K r-x--  /usr/lib/firefox/components/libimglib2.so
b5d9a000      8K rw---  /usr/lib/firefox/components/libimglib2.so
b5d9c000     88K r-x--  /usr/lib/firefox/components/libnsappshell.so
b5db2000      8K rw---  /usr/lib/firefox/components/libnsappshell.so
b5db4000     80K r-x--  /usr/lib/firefox/components/libappcomps.so
b5dc8000      4K rw---  /usr/lib/firefox/components/libappcomps.so
b5dc9000    308K r-x--  /usr/lib/firefox/components/libdocshell.so
b5e16000     16K rw---  /usr/lib/firefox/components/libdocshell.so
b5e1a000     76K r-x--  /usr/lib/firefox/components/libjsd.so
b5e2d000      4K rw---  /usr/lib/firefox/components/libjsd.so
b5e2e000    156K r-x--  /usr/lib/firefox/components/librdf.so
b5e55000      8K rw---  /usr/lib/firefox/components/librdf.so
b6658000    172K r-x--  /usr/lib/firefox/components/libembedcomponents.so
b6683000      8K rw---  /usr/lib/firefox/components/libembedcomponents.so
b6685000    280K r-x--  /usr/lib/firefox/components/libtoolkitcomps.so
b66cb000     12K rw---  /usr/lib/firefox/components/libtoolkitcomps.so
b6709000     72K r-x--  /usr/lib/gtk-2.0/2.10.0/engines/libubuntulooks.so
b671b000      4K rw---  /usr/lib/gtk-2.0/2.10.0/engines/libubuntulooks.so
b673c000     84K r-x--  /usr/lib/libICE.so.6.3.0
b6751000      8K rw---  /usr/lib/libICE.so.6.3.0
b6754000     32K r-x--  /usr/lib/libSM.so.6.0.0
b675c000      4K rw---  /usr/lib/libSM.so.6.0.0
b675d000    308K r-x--  /usr/lib/libXt.so.6.0.0
b67aa000     16K rw---  /usr/lib/libXt.so.6.0.0
b67ae000     20K r-x--  /usr/lib/firefox/components/libsystem-pref.so
b67b3000      4K rw---  /usr/lib/firefox/components/libsystem-pref.so
b67b4000     76K r-x--  /usr/lib/firefox/components/libcaps.so
b67c7000      4K rw---  /usr/lib/firefox/components/libcaps.so
b67c8000     12K r-x--  /usr/lib/firefox/libgtkxtbin.so
b67cb000      4K rw---  /usr/lib/firefox/libgtkxtbin.so
b67cc000    176K r-x--  /usr/lib/firefox/components/libwidget_gtk2.so
b67f8000     16K rw---  /usr/lib/firefox/components/libwidget_gtk2.so
b67fc000     68K r-x--  /usr/lib/firefox/components/libjar50.so
b680d000      8K rw---  /usr/lib/firefox/components/libjar50.so
b680f000    304K r-x--  /usr/lib/firefox/components/libxpconnect.so
b685b000     16K rw---  /usr/lib/firefox/components/libxpconnect.so
b7060000    100K r-x--  /usr/lib/firefox/libxpcom_compat.so
b7079000      4K rw---  /usr/lib/firefox/libxpcom_compat.so
b707b000    116K r-x--  /usr/lib/firefox/libgkgfx.so
b7098000      8K rw---  /usr/lib/firefox/libgkgfx.so
b709a000    232K r-x--  /usr/lib/firefox/components/libbrowsercomps.so
b70d4000     12K rw---  /usr/lib/firefox/components/libbrowsercomps.so
b70d7000    216K r-x--  /usr/lib/firefox/components/libi18n.so
b710d000     12K rw---  /usr/lib/firefox/components/libi18n.so
b7110000    776K r-x--  /usr/lib/firefox/components/libnecko.so
b71d2000     32K rw---  /usr/lib/firefox/components/libnecko.so
b71da000    160K r-x--  /usr/lib/libhunspell-1.1.so.0.0.0
b7202000     68K rw---  /usr/lib/libhunspell-1.1.so.0.0.0
b7214000     28K r-x--  /usr/lib/firefox/components/libautoconfig.so
b721b000      4K rw---  /usr/lib/firefox/components/libautoconfig.so
b721c000     64K r-x--  /usr/lib/firefox/components/libchrome.so
b722c000      4K rw---  /usr/lib/firefox/components/libchrome.so
b7250000     36K r-x--  /lib/tls/i686/cmov/libnss_files-2.5.so
b7259000      8K rw---  /lib/tls/i686/cmov/libnss_files-2.5.so
b725b000     32K r-x--  /lib/tls/i686/cmov/libnss_nis-2.5.so
b7263000      8K rw---  /lib/tls/i686/cmov/libnss_nis-2.5.so
b7265000     76K r-x--  /lib/tls/i686/cmov/libnsl-2.5.so
b7278000      8K rw---  /lib/tls/i686/cmov/libnsl-2.5.so
b727c000     28K r-x--  /lib/tls/i686/cmov/libnss_compat-2.5.so
b7283000      8K rw---  /lib/tls/i686/cmov/libnss_compat-2.5.so
b7286000     60K r-x--  /usr/lib/firefox/components/libpref.so
b7295000      4K rw---  /usr/lib/firefox/components/libpref.so
b7296000     16K r-x--  /usr/lib/firefox/components/libmyspell.so
b729a000      4K rw---  /usr/lib/firefox/components/libmyspell.so
b729b000     12K r-x--  /usr/lib/firefox/components/libbrowserdirprovider.so
b729e000      4K rw---  /usr/lib/firefox/components/libbrowserdirprovider.so
b73c6000    120K r-x--  /usr/lib/libexpat.so.1.0.0
b73e4000      8K rw---  /usr/lib/libexpat.so.1.0.0
b73e6000    136K r-x--  /usr/lib/libpng12.so.0.15.0
b7408000      4K rw---  /usr/lib/libpng12.so.0.15.0
b7409000     76K r-x--  /usr/lib/libz.so.1.2.3
b741c000      4K rw---  /usr/lib/libz.so.1.2.3
b741e000    416K r-x--  /usr/lib/libfreetype.so.6.3.10
b7486000     12K rw---  /usr/lib/libfreetype.so.6.3.10
b7489000    168K r-x--  /usr/lib/libpangoft2-1.0.so.0.1600.2
b74b3000      4K rw---  /usr/lib/libpangoft2-1.0.so.0.1600.2
b74b4000     16K r-x--  /usr/lib/libXdmcp.so.6.0.0
b74b8000      4K rw---  /usr/lib/libXdmcp.so.6.0.0
b74b9000      8K r-x--  /usr/lib/libXau.so.6.0.0
b74bb000      4K rw---  /usr/lib/libXau.so.6.0.0
b74bc000     32K r-x--  /usr/lib/libXcursor.so.1.0.2
b74c4000      4K rw---  /usr/lib/libXcursor.so.1.0.2
b74c6000     20K r-x--  /usr/lib/libXrandr.so.2.1.0
b74cb000      4K rw---  /usr/lib/libXrandr.so.2.1.0
b74cc000     28K r-x--  /usr/lib/libXi.so.6.0.0
b74d3000      4K rw---  /usr/lib/libXi.so.6.0.0
b74d4000      8K r-x--  /usr/lib/libXinerama.so.1.0.0
b74d6000      4K rw---  /usr/lib/libXinerama.so.1.0.0
b74d7000     28K r-x--  /usr/lib/libXrender.so.1.3.0
b74de000      4K rw---  /usr/lib/libXrender.so.1.3.0
b74df000     52K r-x--  /usr/lib/libXext.so.6.4.0
b74ec000      4K rw---  /usr/lib/libXext.so.6.4.0
b74ed000    140K r-x--  /usr/lib/libfontconfig.so.1.2.0
b7510000     32K rw---  /usr/lib/libfontconfig.so.1.2.0
b7519000    440K r-x--  /usr/lib/libcairo.so.2.11.1
b7587000      8K rw---  /usr/lib/libcairo.so.2.11.1
b7589000    592K r-x--  /usr/lib/libglib-2.0.so.0.1200.11
b761d000      4K rw---  /usr/lib/libglib-2.0.so.0.1200.11
b761e000      8K r-x--  /usr/lib/libgmodule-2.0.so.0.1200.11
b7620000      4K rw---  /usr/lib/libgmodule-2.0.so.0.1200.11
b7621000    228K r-x--  /usr/lib/libgobject-2.0.so.0.1200.11
b765a000      4K rw---  /usr/lib/libgobject-2.0.so.0.1200.11
b765b000    100K r-x--  /usr/lib/libatk-1.0.so.0.1809.1
b7674000      8K rw---  /usr/lib/libatk-1.0.so.0.1809.1
b7677000     16K r-x--  /usr/lib/libXfixes.so.3.1.0
b767b000      4K rw---  /usr/lib/libXfixes.so.3.1.0
b767c000    240K r-x--  /usr/lib/libpango-1.0.so.0.1600.2
b76b8000      8K rw---  /usr/lib/libpango-1.0.so.0.1600.2
b76ba000     28K r-x--  /usr/lib/libpangocairo-1.0.so.0.1600.2
b76c1000      4K rw---  /usr/lib/libpangocairo-1.0.so.0.1600.2
b76c2000     88K r-x--  /usr/lib/libgdk_pixbuf-2.0.so.0.1000.11
b76d8000      4K rw---  /usr/lib/libgdk_pixbuf-2.0.so.0.1000.11
b76d9000     44K r-x--  /lib/libgcc_s.so.1
b76e4000      4K rw---  /lib/libgcc_s.so.1
b76e6000      8K r-x--  /lib/tls/i686/cmov/libdl-2.5.so
b76e8000      8K rw---  /lib/tls/i686/cmov/libdl-2.5.so
b76ea000      8K r-x--  /usr/lib/libplds4.so
b76ec000      4K rw---  /usr/lib/libplds4.so
b76ed000    148K r-x--  /lib/tls/i686/cmov/libm-2.5.so
b7712000      8K rw---  /lib/tls/i686/cmov/libm-2.5.so
b7714000   1260K r-x--  /lib/tls/i686/cmov/libc-2.5.so
b784f000      4K r----  /lib/tls/i686/cmov/libc-2.5.so
b7850000      8K rw---  /lib/tls/i686/cmov/libc-2.5.so
b7855000    892K r-x--  /usr/lib/libstdc++.so.6.0.8
b7934000     12K r----  /usr/lib/libstdc++.so.6.0.8
b7937000      8K rw---  /usr/lib/libstdc++.so.6.0.8
b793f000    948K r-x--  /usr/lib/libX11.so.6.2.0
b7a2c000     16K rw---  /usr/lib/libX11.so.6.2.0
b7a31000    524K r-x--  /usr/lib/libgdk-x11-2.0.so.0.1000.11
b7ab4000     12K rw---  /usr/lib/libgdk-x11-2.0.so.0.1000.11
b7ab7000   3396K r-x--  /usr/lib/libgtk-x11-2.0.so.0.1000.11
b7e08000     24K rw---  /usr/lib/libgtk-x11-2.0.so.0.1000.11
b7e0f000     76K r-x--  /lib/tls/i686/cmov/libpthread-2.5.so
b7e22000      8K rw---  /lib/tls/i686/cmov/libpthread-2.5.so
b7e26000    188K r-x--  /usr/lib/libnspr4.so
b7e55000      4K rw---  /usr/lib/libnspr4.so
b7e58000     16K r-x--  /usr/lib/libplc4.so
b7e5c000      4K rw---  /usr/lib/libplc4.so
b7e5d000      4K r-x--  /usr/lib/gtk-2.0/2.10.0/immodules/im-cedilla.so
b7e5e000      4K rw---  /usr/lib/gtk-2.0/2.10.0/immodules/im-cedilla.so
b7e5f000      8K r-x--  /usr/lib/gconv/UTF-16.so
b7e61000      8K rw---  /usr/lib/gconv/UTF-16.so
b7e63000      4K r-x--  /usr/lib/gconv/ISO8859-1.so
b7e64000      8K rw---  /usr/lib/gconv/ISO8859-1.so
b7e77000    656K r-x--  /usr/lib/firefox/libxpcom_core.so
b7f1b000     32K rw---  /usr/lib/firefox/libxpcom_core.so
b7f24000      8K r-x--  /usr/lib/firefox/libxpcom.so
b7f26000      4K rw---  /usr/lib/firefox/libxpcom.so
b7f27000    668K r-x--  /usr/lib/firefox/libmozjs.so
b7fce000     20K rw---  /usr/lib/firefox/libmozjs.so
b7fd5000    100K r-x--  /lib/ld-2.5.so
b7fee000      8K rw---  /lib/ld-2.5.so

