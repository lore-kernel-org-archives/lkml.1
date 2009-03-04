Return-Path: <linux-kernel-owner+w=401wt.eu-S1756039AbZCDSr2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756039AbZCDSr2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Mar 2009 13:47:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753659AbZCDSrT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Mar 2009 13:47:19 -0500
Received: from mail-ew0-f177.google.com ([209.85.219.177]:65212 "EHLO
	mail-ew0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753323AbZCDSrR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Mar 2009 13:47:17 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer;
        b=lZk+l3UQPfrlbvE29g0p0McWJJJC/Q3Atcc1mf6oIAl+PcjTnCdLX3rQgaez/uCxdR
         KQK75BSdLOtOU24UF01TSjjixbSla0Yovqspzc3RuZ8I6yl+Um1SgAqldDyhWsWEAle8
         0gt7SX4rx/JtnQvHA3SJvhPdLvNTTBQw9GOjM=
Subject: Re: [RFC PATCH 0/6] module, kbuild: Faster boot with custom kernel.
From: Andreas Robinson <andr345@gmail.com>
To: Arjan van de Ven <arjan@infradead.org>
Cc: Kay Sievers <kay.sievers@vrfy.org>, Rusty Russell <rusty@rustcorp.com.au>,
       sam@ravnborg.org, linux-kernel@vger.kernel.org
In-Reply-To: <20090302102703.50aaf724@infradead.org>
References: <1234722028-8110-1-git-send-email-andr345@gmail.com>
	 <ac3eb2510902170353ia62a630nbe5cf059ca7d616e@mail.gmail.com>
	 <200902181528.29697.rusty@rustcorp.com.au>
	 <ac3eb2510902180115o4690a335n129e4df695540de0@mail.gmail.com>
	 <1234952753.10531.48.camel@andreas-laptop>
	 <cc43514a0902191637h5a9680c5id95f7d6c32cca472@mail.gmail.com>
	 <ac3eb2510902191755i391d4defnc5a514f4525ec6cf@mail.gmail.com>
	 <1235216636.7025.1023.camel@andreas-laptop>
	 <1236004353.10055.49.camel@andreas-laptop>
	 <20090302082003.1bb7bdc5@infradead.org>
	 <ac3eb2510903020829s7c876a96y7eb5568eeb9921fd@mail.gmail.com>
	 <20090302102703.50aaf724@infradead.org>
Content-Type: multipart/mixed; boundary="=-gtK0ijxj+2IqmfStKzyo"
Date: Wed, 04 Mar 2009 19:47:10 +0100
Message-Id: <1236192430.6785.111.camel@andreas-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-gtK0ijxj+2IqmfStKzyo
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

On Mon, 2009-03-02 at 10:27 -0800, Arjan van de Ven wrote:
> On Mon, 2 Mar 2009 17:29:57 +0100
> Kay Sievers <kay.sievers@vrfy.org> wrote:
> 
> > On Mon, Mar 2, 2009 at 17:20, Arjan van de Ven <arjan@infradead.org>
> > wrote:

[...]

> > > I would strongly suggest that you turn on the async function calls
> > > and look at the boot graph of the resulting kernel boot... if you
> > > send that to me I can also take a look and make suggestions....
> > 
> > The "fastboot" kernel commandline option was used, as mentioned in the
> > mail. Is there anything else?
> 
> there is some sata level enabling needed depending on the system;
> I'd love to see the bootgraph (scripts/bootgraph.pl) for the boot;
> that shows exactly what happens when and for how long.
> 
Well, this was certainly an eye opener. I can only say thanks for
pointing out bootgraph!

You asked for one graph, but Rusty suggested that I compare insmod and
modprobe (though in another context), so I did more than one.

The (somewhat messy) combined result from booting four initramfs images
with slightly different setups is attached. 

All of them install the 94 modules needed on the test system and all use
2.6.29-rc6 configured like a Ubuntu 8.10 generic kernel. The module
mutex minimizing patch is added, but not the stop_machine patch. (The
merge failed due to my own patches. I need to have a look at it again.)
Fastboot is enabled.

bootgraph.pl was tweaked to, among other things, not stop until when a
dummy module was inserted. This happened after udev had settled and just
before chaining to the file system on the hard drive.

1: (top row, light blue). This installed modules using udev 124 and
modprobe 3.3pre11 that are shipped with Ubuntu 8.10.

2: (second row, light green). This installed modules using the latest
versions of udev (139) and modprobe (3.7pre6) from the git repos.

3: (third row, light yellow). This used a multithreaded insmod. It
employs a very simple method to spawn child processes, so it looks
different from the others and had to be compressed vertically to fit.
(And four processes hang until all initcalls are done and the parent
process dies, so it's kind of buggy too.)

4: (bottom row, pink). This is the megamodule, only added out of
curiosity. It really is multithreaded, but it doesn't use
do_one_initcall() so you can't see anything.


--=-gtK0ijxj+2IqmfStKzyo
Content-Disposition: attachment; filename="bootgraph.svg"
Content-Type: image/svg+xml; name="bootgraph.svg"
Content-Transfer-Encoding: 7bit

<?xml version="1.0" encoding="UTF-8" standalone="no"?>
<!-- Created with Inkscape (http://www.inkscape.org/) -->
<svg
   xmlns:dc="http://purl.org/dc/elements/1.1/"
   xmlns:cc="http://creativecommons.org/ns#"
   xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
   xmlns:svg="http://www.w3.org/2000/svg"
   xmlns="http://www.w3.org/2000/svg"
   xmlns:sodipodi="http://sodipodi.sourceforge.net/DTD/sodipodi-0.dtd"
   xmlns:inkscape="http://www.inkscape.org/namespaces/inkscape"
   width="1912.1841"
   height="3356.989"
   id="svg3522"
   sodipodi:version="0.32"
   inkscape:version="0.46"
   version="1.0"
   sodipodi:docname="bootgraph.svg"
   inkscape:output_extension="org.inkscape.output.svg.inkscape">
  <defs
     id="defs3524">
    <inkscape:perspective
       sodipodi:type="inkscape:persp3d"
       inkscape:vp_x="0 : 526.18109 : 1"
       inkscape:vp_y="0 : 1000 : 0"
       inkscape:vp_z="744.09448 : 526.18109 : 1"
       inkscape:persp3d-origin="372.04724 : 350.78739 : 1"
       id="perspective3530" />
  </defs>
  <sodipodi:namedview
     id="base"
     pagecolor="#ffffff"
     bordercolor="#666666"
     borderopacity="1.0"
     gridtolerance="10000"
     guidetolerance="10"
     objecttolerance="10"
     inkscape:pageopacity="0.0"
     inkscape:pageshadow="2"
     inkscape:zoom="0.69999999"
     inkscape:cx="572.39517"
     inkscape:cy="709.31073"
     inkscape:document-units="px"
     inkscape:current-layer="layer1"
     showgrid="false"
     inkscape:window-width="1200"
     inkscape:window-height="726"
     inkscape:window-x="33"
     inkscape:window-y="25" />
  <metadata
     id="metadata3527">
    <rdf:RDF>
      <cc:Work
         rdf:about="">
        <dc:format>image/svg+xml</dc:format>
        <dc:type
           rdf:resource="http://purl.org/dc/dcmitype/StillImage" />
      </cc:Work>
    </rdf:RDF>
  </metadata>
  <g
     inkscape:label="Layer 1"
     inkscape:groupmode="layer"
     id="layer1"
     transform="translate(584.72937,1013.4344)">
    <g
       id="g3408"
       transform="translate(-577.28481,-935.28332)">
      <rect
         id="rect2913"
         style="fill:#80ffff;fill-opacity:0.5;stroke:#000000;stroke-width:1"
         height="145"
         y="150"
         width="3.719625"
         x="93.604332" />
      <text
         id="text2915"
         font-size="3pt"
         transform="matrix(0,1,-1,0,94.604333,154)"
         style="font-size:3.75px">acpi_init</text>
      <rect
         id="rect2917"
         style="fill:#80ffff;fill-opacity:0.5;stroke:#000000;stroke-width:1"
         height="145"
         y="150"
         width="4.5749168"
         x="97.356461" />
      <text
         id="text2919"
         font-size="3pt"
         transform="matrix(0,1,-1,0,98.356458,154)"
         style="font-size:3.75px">acpi_scan_init</text>
      <rect
         id="rect2921"
         style="fill:#80ffff;fill-opacity:0.5;stroke:#000000;stroke-width:1"
         height="145"
         y="150"
         width="26.641333"
         x="102.05921" />
      <text
         id="text2923"
         transform="matrix(0,1,-1,0,108.05921,154)">acpi_pci_root_init</text>
      <rect
         id="rect2925"
         style="fill:#80ffff;fill-opacity:0.5;stroke:#000000;stroke-width:1"
         height="145"
         y="150"
         width="5.6382084"
         x="128.70055" />
      <text
         id="text2927"
         font-size="3pt"
         transform="matrix(0,1,-1,0,129.70054,154)"
         style="font-size:3.75px">acpi_pci_link_init</text>
      <rect
         id="rect2929"
         style="fill:#80ffff;fill-opacity:0.5;stroke:#000000;stroke-width:1"
         height="145"
         y="150"
         width="10.547334"
         x="134.62421" />
      <text
         id="text2931"
         font-size="3pt"
         transform="matrix(0,1,-1,0,135.62421,154)"
         style="font-size:3.75px">genl_init</text>
      <rect
         id="rect2933"
         style="fill:#80ffff;fill-opacity:0.5;stroke:#000000;stroke-width:1"
         height="145"
         y="150"
         width="2.0707917"
         x="145.26796" />
      <text
         id="text2935"
         font-size="3pt"
         transform="matrix(0,1,-1,0,146.26796,154)"
         style="font-size:3.75px">atm_init</text>
      <rect
         id="rect2937"
         style="fill:#80ffff;fill-opacity:0.5;stroke:#000000;stroke-width:1"
         height="145"
         y="150"
         width="1.6900001"
         x="147.82083" />
      <text
         id="text2939"
         font-size="3pt"
         transform="matrix(0,1,-1,0,148.82083,154)"
         style="font-size:3.75px">hpet_late_init</text>
      <rect
         id="rect2941"
         style="fill:#80ffff;fill-opacity:0.5;stroke:#000000;stroke-width:1"
         height="145"
         y="150"
         width="6.5482082"
         x="150.01784" />
      <text
         id="text2943"
         font-size="3pt"
         transform="matrix(0,1,-1,0,151.01783,154)"
         style="font-size:3.75px">acpi_event_init</text>
      <rect
         id="rect2945"
         style="fill:#80ffff;fill-opacity:0.5;stroke:#000000;stroke-width:1"
         height="145"
         y="150"
         width="2.6287084"
         x="156.59909" />
      <text
         id="text2947"
         font-size="3pt"
         transform="matrix(0,1,-1,0,157.59908,154)"
         style="font-size:3.75px">pnpacpi_init</text>
      <rect
         id="rect2949"
         style="fill:#80ffff;fill-opacity:0.5;stroke:#000000;stroke-width:1"
         height="145"
         y="150"
         width="18.730291"
         x="160.45088" />
      <text
         id="text2951"
         transform="matrix(0,1,-1,0,166.45087,154)">init_acpi_pm_clocksource</text>
      <rect
         id="rect2953"
         style="fill:#80ffff;fill-opacity:0.5;stroke:#000000;stroke-width:1"
         height="145"
         y="150"
         width="30.7775"
         x="179.99962" />
      <text
         id="text2955"
         transform="matrix(0,1,-1,0,185.99962,154)">inet_init</text>
      <rect
         id="rect2957"
         style="fill:#80ffff;fill-opacity:0.5;stroke:#000000;stroke-width:1"
         height="145"
         y="150"
         width="147.08092"
         x="210.912" />
      <text
         id="text2959"
         transform="matrix(0,1,-1,0,216.912,154)">populate_rootfs</text>
      <rect
         id="rect2961"
         style="fill:#80ffff;fill-opacity:0.5;stroke:#000000;stroke-width:1"
         height="145"
         y="150"
         width="3.6665416"
         x="361.71201" />
      <text
         id="text2963"
         font-size="3pt"
         transform="matrix(0,1,-1,0,362.712,154)"
         style="font-size:3.75px">init_kprobes</text>
      <rect
         id="rect2965"
         style="fill:#80ffff;fill-opacity:0.5;stroke:#000000;stroke-width:1"
         height="145"
         y="150"
         width="1.841125"
         x="366.67151" />
      <text
         id="text2967"
         font-size="3pt"
         transform="matrix(0,1,-1,0,367.6715,154)"
         style="font-size:3.75px">slab_sysfs_init</text>
      <rect
         id="rect2969"
         style="fill:#80ffff;fill-opacity:0.5;stroke:#000000;stroke-width:1"
         height="145"
         y="150"
         width="110.08346"
         x="373.24896" />
      <text
         id="text2971"
         transform="matrix(0,1,-1,0,379.24896,154)">pci_init</text>
      <rect
         id="rect2973"
         style="fill:#80ffff;fill-opacity:0.5;stroke:#000000;stroke-width:1"
         height="145"
         y="150"
         width="191.43042"
         x="484.29874" />
      <text
         id="text2975"
         transform="matrix(0,1,-1,0,490.29875,154)">isapnp_init</text>
      <rect
         id="rect2977"
         style="fill:#80ffff;fill-opacity:0.5;stroke:#000000;stroke-width:1"
         height="145"
         y="150"
         width="1.6520833"
         x="675.86188" />
      <text
         id="text2979"
         font-size="3pt"
         transform="matrix(0,1,-1,0,676.86188,154)"
         style="font-size:3.75px">tty_init</text>
      <rect
         id="rect2981"
         style="fill:#80ffff;fill-opacity:0.5;stroke:#000000;stroke-width:1"
         height="145"
         y="150"
         width="23.568459"
         x="677.55353" />
      <text
         id="text2983"
         transform="matrix(0,1,-1,0,683.5535,154)">pty_init</text>
      <rect
         id="rect2985"
         style="fill:#80ffff;fill-opacity:0.5;stroke:#000000;stroke-width:1"
         height="145"
         y="150"
         width="9.8567085"
         x="703.99115" />
      <text
         id="text2987"
         font-size="3pt"
         transform="matrix(0,1,-1,0,704.99117,154)"
         style="font-size:3.75px">i8042_init</text>
      <rect
         id="rect2989"
         style="fill:#80ffff;fill-opacity:0.5;stroke:#000000;stroke-width:1"
         height="145"
         y="150"
         width="8.3113337"
         x="713.88092" />
      <text
         id="text2991"
         font-size="3pt"
         transform="matrix(0,1,-1,0,714.88092,154)"
         style="font-size:3.75px">mousedev_init</text>
      <rect
         id="rect2993"
         style="fill:#80ffff;fill-opacity:0.5;stroke:#000000;stroke-width:1"
         height="145"
         y="300"
         width="2.0252917"
         x="859.64935" />
      <text
         id="text2995"
         font-size="3pt"
         transform="matrix(0,1,-1,0,860.64937,304)"
         style="font-size:3.75px">acpi_thermal_init</text>
      <rect
         id="rect2997"
         style="fill:#80ffff;fill-opacity:0.5;stroke:#000000;stroke-width:1"
         height="145"
         y="450"
         width="23.628584"
         x="863.14478" />
      <text
         id="text2999"
         transform="matrix(0,1,-1,0,869.14475,454)">acpi_button_init</text>
      <rect
         id="rect3001"
         style="fill:#80ffff;fill-opacity:0.5;stroke:#000000;stroke-width:1"
         height="145"
         y="600"
         width="10.488833"
         x="901.76831" />
      <text
         id="text3003"
         font-size="3pt"
         transform="matrix(0,1,-1,0,902.76829,604)"
         style="font-size:3.75px">acpi_video_init</text>
      <rect
         id="rect3005"
         style="fill:#80ffff;fill-opacity:0.5;stroke:#000000;stroke-width:1"
         height="145"
         y="750"
         width="1.733875"
         x="980.97131" />
      <text
         id="text3007"
         font-size="3pt"
         transform="matrix(0,1,-1,0,981.97133,754)"
         style="font-size:3.75px">mmc_init</text>
      <rect
         id="rect3009"
         style="fill:#80ffff;fill-opacity:0.5;stroke:#000000;stroke-width:1"
         height="145"
         y="900"
         width="192.14163"
         x="1025.6903" />
      <text
         id="text3011"
         transform="matrix(0,1,-1,0,1031.6903,904)">alsa_card_azx_init</text>
      <rect
         id="rect3013"
         style="fill:#80ffff;fill-opacity:0.5;stroke:#000000;stroke-width:1"
         height="145"
         y="1050"
         width="461.89108"
         x="1038.0223" />
      <text
         id="text3015"
         transform="matrix(0,1,-1,0,1044.0224,1054)">init_nic</text>
      <rect
         id="rect3017"
         style="fill:#80ffff;fill-opacity:0.5;stroke:#000000;stroke-width:1"
         height="145"
         y="1200"
         width="34.114166"
         x="1040.2307" />
      <text
         id="text3019"
         transform="matrix(0,1,-1,0,1046.2308,1204)">ohci1394_init</text>
      <rect
         id="rect3021"
         style="fill:#80ffff;fill-opacity:0.5;stroke:#000000;stroke-width:1"
         height="145"
         y="1350"
         width="489.19867"
         x="1041.8677" />
      <text
         id="text3023"
         transform="matrix(0,1,-1,0,1047.8677,1354)">ohci_hcd_mod_init</text>
      <rect
         id="rect3025"
         style="fill:#80ffff;fill-opacity:0.5;stroke:#000000;stroke-width:1"
         height="145"
         y="1500"
         width="492.31812"
         x="1044.1823" />
      <text
         id="text3027"
         transform="matrix(0,1,-1,0,1050.1822,1504)">ehci_hcd_init</text>
      <rect
         id="rect3029"
         style="fill:#80ffff;fill-opacity:0.5;stroke:#000000;stroke-width:1"
         height="145"
         y="1650"
         width="491.88208"
         x="1044.7726" />
      <text
         id="text3031"
         transform="matrix(0,1,-1,0,1050.7726,1654)">k8temp_init</text>
      <rect
         id="rect3033"
         style="fill:#80ffff;fill-opacity:0.5;stroke:#000000;stroke-width:1"
         height="145"
         y="750"
         width="29.745083"
         x="1046.7795" />
      <text
         id="text3035"
         transform="matrix(0,1,-1,0,1052.7795,754)">sdhci_drv_init</text>
      <rect
         id="rect3037"
         style="fill:#80ffff;fill-opacity:0.5;stroke:#000000;stroke-width:1"
         height="145"
         y="1800"
         width="10.728791"
         x="1050.9856" />
      <text
         id="text3039"
         font-size="3pt"
         transform="matrix(0,1,-1,0,1051.9855,1804)"
         style="font-size:3.75px">pcspkr_init</text>
      <rect
         id="rect3041"
         style="fill:#80ffff;fill-opacity:0.5;stroke:#000000;stroke-width:1"
         height="145"
         y="1950"
         width="485.86578"
         x="1052.1772" />
      <text
         id="text3043"
         transform="matrix(0,1,-1,0,1058.1772,1954)">pacpi_init</text>
      <rect
         id="rect3045"
         style="fill:#80ffff;fill-opacity:0.5;stroke:#000000;stroke-width:1"
         height="145"
         y="2100"
         width="76.89283"
         x="1054.1943" />
      <text
         id="text3047"
         transform="matrix(0,1,-1,0,1060.1944,2104)">evdev_init</text>
      <rect
         id="rect3049"
         style="fill:#80ffff;fill-opacity:0.5;stroke:#000000;stroke-width:1"
         height="145"
         y="2250"
         width="9.4396248"
         x="1531.744" />
      <text
         id="text3051"
         font-size="3pt"
         transform="matrix(0,1,-1,0,1532.744,2254)"
         style="font-size:3.75px">joydev_init</text>
      <rect
         id="rect3053"
         style="fill:#80ffff;fill-opacity:0.5;stroke:#000000;stroke-width:1"
         height="145"
         y="2400"
         width="3.128125"
         x="1547.5092" />
      <text
         id="text3055"
         font-size="3pt"
         transform="matrix(0,1,-1,0,1548.5092,2404)"
         style="font-size:3.75px">nv_init</text>
      <rect
         id="rect3057"
         style="fill:#80ffff;fill-opacity:0.5;stroke:#000000;stroke-width:1"
         height="145"
         y="2550"
         width="7.1890001"
         x="1654.2473" />
      <text
         id="text3059"
         font-size="3pt"
         transform="matrix(0,1,-1,0,1655.2473,2554)"
         style="font-size:3.75px">init_sr</text>
      <rect
         id="rect3061"
         style="fill:#80ffff;fill-opacity:0.5;stroke:#000000;stroke-width:1"
         height="145"
         y="2700"
         width="8.1602087"
         x="1790.308" />
      <text
         id="text3063"
         font-size="3pt"
         transform="matrix(0,1,-1,0,1791.308,2704)"
         style="font-size:3.75px">uvc_init</text>
      <text
         id="text3065"
         transform="matrix(0,1,-1,0,0,89)">0</text>
      <text
         id="text3067"
         transform="matrix(0,1,-1,0,54.166667,89)">0.1</text>
      <text
         id="text3069"
         transform="matrix(0,1,-1,0,108.33333,89)">0.2</text>
      <text
         id="text3071"
         transform="matrix(0,1,-1,0,162.5,89)">0.3</text>
      <text
         id="text3073"
         transform="matrix(0,1,-1,0,216.66667,89)">0.4</text>
      <text
         id="text3075"
         transform="matrix(0,1,-1,0,270.83333,89)">0.5</text>
      <text
         id="text3077"
         transform="matrix(0,1,-1,0,325,89)">0.6</text>
      <text
         id="text3079"
         transform="matrix(0,1,-1,0,379.16667,89)">0.7</text>
      <text
         id="text3081"
         transform="matrix(0,1,-1,0,433.33333,89)">0.8</text>
      <text
         id="text3083"
         transform="matrix(0,1,-1,0,487.5,89)">0.89</text>
      <text
         id="text3085"
         transform="matrix(0,1,-1,0,541.66667,89)">0.99</text>
      <text
         id="text3087"
         transform="matrix(0,1,-1,0,595.83333,89)">1.09</text>
      <text
         id="text3089"
         transform="matrix(0,1,-1,0,650,89)">1.2</text>
      <text
         id="text3091"
         transform="matrix(0,1,-1,0,704.16667,89)">1.3</text>
      <text
         id="text3093"
         transform="matrix(0,1,-1,0,758.33333,89)">1.4</text>
      <text
         id="text3095"
         transform="matrix(0,1,-1,0,812.5,89)">1.5</text>
      <text
         id="text3097"
         transform="matrix(0,1,-1,0,866.66667,89)">1.6</text>
      <text
         id="text3099"
         transform="matrix(0,1,-1,0,920.83333,89)">1.7</text>
      <text
         id="text3101"
         transform="matrix(0,1,-1,0,975,89)">1.8</text>
      <text
         id="text3103"
         transform="matrix(0,1,-1,0,1029.1667,89)">1.9</text>
      <text
         id="text3105"
         transform="matrix(0,1,-1,0,1083.3333,89)">2</text>
      <text
         id="text3107"
         transform="matrix(0,1,-1,0,1137.5,89)">2.1</text>
      <text
         id="text3109"
         transform="matrix(0,1,-1,0,1191.6667,89)">2.2</text>
      <text
         id="text3111"
         transform="matrix(0,1,-1,0,1245.8333,89)">2.3</text>
      <text
         id="text3113"
         transform="matrix(0,1,-1,0,1300,89)">2.4</text>
      <text
         id="text3115"
         transform="matrix(0,1,-1,0,1354.1667,89)">2.5</text>
      <text
         id="text3117"
         transform="matrix(0,1,-1,0,1408.3333,89)">2.6</text>
      <text
         id="text3119"
         transform="matrix(0,1,-1,0,1462.5,89)">2.7</text>
      <text
         id="text3121"
         transform="matrix(0,1,-1,0,1516.6667,89)">2.8</text>
      <text
         id="text3123"
         transform="matrix(0,1,-1,0,1570.8333,89)">2.9</text>
      <text
         id="text3125"
         transform="matrix(0,1,-1,0,1625,89)">3</text>
      <text
         id="text3127"
         transform="matrix(0,1,-1,0,1679.1667,89)">3.1</text>
      <text
         id="text3129"
         transform="matrix(0,1,-1,0,1733.3333,89)">3.2</text>
      <text
         id="text3131"
         transform="matrix(0,1,-1,0,1787.5,89)">3.3</text>
      <text
         id="text3133"
         transform="matrix(0,1,-1,0,1841.6667,89)">3.4</text>
      <text
         id="text3135"
         transform="matrix(0,1,-1,0,1895.8333,89)">3.5</text>
    </g>
    <g
       id="g3144"
       transform="translate(-582.63029,-770.95912)">
      <rect
         id="rect2672"
         style="fill:#00ff80;fill-opacity:0.5;stroke:#000000;stroke-width:1"
         height="145"
         y="150"
         width="3.6833334"
         x="93.76683" />
      <text
         id="text2674"
         font-size="3pt"
         transform="matrix(0,1,-1,0,94.766833,154)"
         style="font-size:3.75px">acpi_init</text>
      <rect
         id="rect2676"
         style="fill:#00ff80;fill-opacity:0.5;stroke:#000000;stroke-width:1"
         height="145"
         y="150"
         width="4.4503331"
         x="97.482666" />
      <text
         id="text2678"
         font-size="3pt"
         transform="matrix(0,1,-1,0,98.482667,154)"
         style="font-size:3.75px">acpi_scan_init</text>
      <rect
         id="rect2680"
         style="fill:#00ff80;fill-opacity:0.5;stroke:#000000;stroke-width:1"
         height="145"
         y="150"
         width="2.0729582"
         x="101.933" />
      <text
         id="text2682"
         font-size="3pt"
         transform="matrix(0,1,-1,0,102.933,154)"
         style="font-size:3.75px">acpi_ec_init</text>
      <rect
         id="rect2684"
         style="fill:#00ff80;fill-opacity:0.5;stroke:#000000;stroke-width:1"
         height="145"
         y="150"
         width="24.480625"
         x="104.21883" />
      <text
         id="text2686"
         transform="matrix(0,1,-1,0,110.21883,154)">acpi_pci_root_init</text>
      <rect
         id="rect2688"
         style="fill:#00ff80;fill-opacity:0.5;stroke:#000000;stroke-width:1"
         height="145"
         y="150"
         width="5.6392918"
         x="128.69946" />
      <text
         id="text2690"
         font-size="3pt"
         transform="matrix(0,1,-1,0,129.69946,154)"
         style="font-size:3.75px">acpi_pci_link_init</text>
      <rect
         id="rect2692"
         style="fill:#00ff80;fill-opacity:0.5;stroke:#000000;stroke-width:1"
         height="145"
         y="150"
         width="1.9586667"
         x="134.58087" />
      <text
         id="text2694"
         font-size="3pt"
         transform="matrix(0,1,-1,0,135.58087,154)"
         style="font-size:3.75px">net_dev_init</text>
      <rect
         id="rect2696"
         style="fill:#00ff80;fill-opacity:0.5;stroke:#000000;stroke-width:1"
         height="145"
         y="150"
         width="8.312417"
         x="136.85913" />
      <text
         id="text2698"
         font-size="3pt"
         transform="matrix(0,1,-1,0,137.85912,154)"
         style="font-size:3.75px">genl_init</text>
      <rect
         id="rect2700"
         style="fill:#00ff80;fill-opacity:0.5;stroke:#000000;stroke-width:1"
         height="145"
         y="150"
         width="2.0707917"
         x="145.26796" />
      <text
         id="text2702"
         font-size="3pt"
         transform="matrix(0,1,-1,0,146.26796,154)"
         style="font-size:3.75px">atm_init</text>
      <rect
         id="rect2704"
         style="fill:#00ff80;fill-opacity:0.5;stroke:#000000;stroke-width:1"
         height="145"
         y="150"
         width="1.691625"
         x="147.81813" />
      <text
         id="text2706"
         font-size="3pt"
         transform="matrix(0,1,-1,0,148.81812,154)"
         style="font-size:3.75px">hpet_late_init</text>
      <rect
         id="rect2708"
         style="fill:#00ff80;fill-opacity:0.5;stroke:#000000;stroke-width:1"
         height="145"
         y="150"
         width="6.5492916"
         x="150.01675" />
      <text
         id="text2710"
         font-size="3pt"
         transform="matrix(0,1,-1,0,151.01675,154)"
         style="font-size:3.75px">acpi_event_init</text>
      <rect
         id="rect2712"
         style="fill:#00ff80;fill-opacity:0.5;stroke:#000000;stroke-width:1"
         height="145"
         y="150"
         width="2.5165834"
         x="156.59909" />
      <text
         id="text2714"
         font-size="3pt"
         transform="matrix(0,1,-1,0,157.59908,154)"
         style="font-size:3.75px">pnpacpi_init</text>
      <rect
         id="rect2716"
         style="fill:#00ff80;fill-opacity:0.5;stroke:#000000;stroke-width:1"
         height="145"
         y="150"
         width="18.729208"
         x="160.41621" />
      <text
         id="text2718"
         transform="matrix(0,1,-1,0,166.41621,154)">init_acpi_pm_clocksource</text>
      <rect
         id="rect2720"
         style="fill:#00ff80;fill-opacity:0.5;stroke:#000000;stroke-width:1"
         height="145"
         y="150"
         width="30.815958"
         x="179.96063" />
      <text
         id="text2722"
         transform="matrix(0,1,-1,0,185.96062,154)">inet_init</text>
      <rect
         id="rect2724"
         style="fill:#00ff80;fill-opacity:0.5;stroke:#000000;stroke-width:1"
         height="145"
         y="150"
         width="151.56483"
         x="210.91362" />
      <text
         id="text2726"
         transform="matrix(0,1,-1,0,216.91362,154)">populate_rootfs</text>
      <rect
         id="rect2728"
         style="fill:#00ff80;fill-opacity:0.5;stroke:#000000;stroke-width:1"
         height="145"
         y="150"
         width="3.6703334"
         x="366.18942" />
      <text
         id="text2730"
         font-size="3pt"
         transform="matrix(0,1,-1,0,367.18942,154)"
         style="font-size:3.75px">init_kprobes</text>
      <rect
         id="rect2732"
         style="fill:#00ff80;fill-opacity:0.5;stroke:#000000;stroke-width:1"
         height="145"
         y="150"
         width="1.8135"
         x="371.15649" />
      <text
         id="text2734"
         font-size="3pt"
         transform="matrix(0,1,-1,0,372.1565,154)"
         style="font-size:3.75px">slab_sysfs_init</text>
      <rect
         id="rect2736"
         style="fill:#00ff80;fill-opacity:0.5;stroke:#000000;stroke-width:1"
         height="145"
         y="150"
         width="110.52871"
         x="377.7486" />
      <text
         id="text2738"
         transform="matrix(0,1,-1,0,383.74858,154)">pci_init</text>
      <rect
         id="rect2740"
         style="fill:#00ff80;fill-opacity:0.5;stroke:#000000;stroke-width:1"
         height="145"
         y="150"
         width="191.48242"
         x="489.31406" />
      <text
         id="text2742"
         transform="matrix(0,1,-1,0,495.31404,154)">isapnp_init</text>
      <rect
         id="rect2744"
         style="fill:#00ff80;fill-opacity:0.5;stroke:#000000;stroke-width:1"
         height="145"
         y="150"
         width="2.1287501"
         x="680.93512" />
      <text
         id="text2746"
         font-size="3pt"
         transform="matrix(0,1,-1,0,681.93512,154)"
         style="font-size:3.75px">tty_init</text>
      <rect
         id="rect2748"
         style="fill:#00ff80;fill-opacity:0.5;stroke:#000000;stroke-width:1"
         height="145"
         y="150"
         width="21.568624"
         x="683.09747" />
      <text
         id="text2750"
         transform="matrix(0,1,-1,0,689.09746,154)">pty_init</text>
      <rect
         id="rect2752"
         style="fill:#00ff80;fill-opacity:0.5;stroke:#000000;stroke-width:1"
         height="145"
         y="150"
         width="10.64375"
         x="707.53314" />
      <text
         id="text2754"
         font-size="3pt"
         transform="matrix(0,1,-1,0,708.53313,154)"
         style="font-size:3.75px">i8042_init</text>
      <rect
         id="rect2756"
         style="fill:#00ff80;fill-opacity:0.5;stroke:#000000;stroke-width:1"
         height="145"
         y="150"
         width="8.3178329"
         x="718.2099" />
      <text
         id="text2758"
         font-size="3pt"
         transform="matrix(0,1,-1,0,719.20992,154)"
         style="font-size:3.75px">mousedev_init</text>
      <rect
         id="rect2760"
         style="fill:#00ff80;fill-opacity:0.5;stroke:#000000;stroke-width:1"
         height="145"
         y="300"
         width="17.693001"
         x="786.50433" />
      <text
         id="text2762"
         transform="matrix(0,1,-1,0,792.50433,304)">acpi_button_init</text>
      <rect
         id="rect2764"
         style="fill:#00ff80;fill-opacity:0.5;stroke:#000000;stroke-width:1"
         height="145"
         y="450"
         width="2.3594999"
         x="791.55536" />
      <text
         id="text2766"
         font-size="3pt"
         transform="matrix(0,1,-1,0,792.55538,454)"
         style="font-size:3.75px">acpi_thermal_init</text>
      <rect
         id="rect2768"
         style="fill:#00ff80;fill-opacity:0.5;stroke:#000000;stroke-width:1"
         height="145"
         y="600"
         width="4.5034165"
         x="793.99341" />
      <text
         id="text2770"
         font-size="3pt"
         transform="matrix(0,1,-1,0,794.99342,604)"
         style="font-size:3.75px">acpi_ac_init</text>
      <rect
         id="rect2772"
         style="fill:#00ff80;fill-opacity:0.5;stroke:#000000;stroke-width:1"
         height="145"
         y="750"
         width="7.616375"
         x="803.36371" />
      <text
         id="text2774"
         font-size="3pt"
         transform="matrix(0,1,-1,0,804.36371,754)"
         style="font-size:3.75px">acpi_video_init</text>
      <rect
         id="rect2776"
         style="fill:#00ff80;fill-opacity:0.5;stroke:#000000;stroke-width:1"
         height="145"
         y="900"
         width="282.18451"
         x="852.13104" />
      <text
         id="text2778"
         transform="matrix(0,1,-1,0,858.13104,904)">init_nic</text>
      <rect
         id="rect2780"
         style="fill:#00ff80;fill-opacity:0.5;stroke:#000000;stroke-width:1"
         height="145"
         y="1050"
         width="280.6218"
         x="853.80804" />
      <text
         id="text2782"
         transform="matrix(0,1,-1,0,859.80804,1054)">k8temp_init</text>
      <rect
         id="rect2784"
         style="fill:#00ff80;fill-opacity:0.5;stroke:#000000;stroke-width:1"
         height="145"
         y="1200"
         width="66.12558"
         x="854.81665" />
      <text
         id="text2786"
         transform="matrix(0,1,-1,0,860.81663,1204)">evdev_init</text>
      <rect
         id="rect2788"
         style="fill:#00ff80;fill-opacity:0.5;stroke:#000000;stroke-width:1"
         height="145"
         y="1350"
         width="266.31366"
         x="869.16486" />
      <text
         id="text2790"
         transform="matrix(0,1,-1,0,875.16483,1354)">nv_init</text>
      <rect
         id="rect2792"
         style="fill:#00ff80;fill-opacity:0.5;stroke:#000000;stroke-width:1"
         height="145"
         y="1500"
         width="66.005875"
         x="872.27673" />
      <text
         id="text2794"
         transform="matrix(0,1,-1,0,878.27671,1504)">pcspkr_init</text>
      <rect
         id="rect2796"
         style="fill:#00ff80;fill-opacity:0.5;stroke:#000000;stroke-width:1"
         height="145"
         y="1650"
         width="294.203"
         x="873.41528" />
      <text
         id="text2798"
         transform="matrix(0,1,-1,0,879.41529,1654)">ohci_hcd_mod_init</text>
      <rect
         id="rect2800"
         style="fill:#00ff80;fill-opacity:0.5;stroke:#000000;stroke-width:1"
         height="145"
         y="1800"
         width="298.14578"
         x="874.90485" />
      <text
         id="text2802"
         transform="matrix(0,1,-1,0,880.90487,1804)">ehci_hcd_init</text>
      <rect
         id="rect2804"
         style="fill:#00ff80;fill-opacity:0.5;stroke:#000000;stroke-width:1"
         height="145"
         y="1950"
         width="471.85666"
         x="893.86755" />
      <text
         id="text2806"
         transform="matrix(0,1,-1,0,899.86754,1954)">alsa_card_azx_init</text>
      <rect
         id="rect2808"
         style="fill:#00ff80;fill-opacity:0.5;stroke:#000000;stroke-width:1"
         height="145"
         y="2100"
         width="2.1265833"
         x="896.49463" />
      <text
         id="text2810"
         font-size="3pt"
         transform="matrix(0,1,-1,0,897.49463,2104)"
         style="font-size:3.75px">sdhci_drv_init</text>
      <rect
         id="rect2812"
         style="fill:#00ff80;fill-opacity:0.5;stroke:#000000;stroke-width:1"
         height="145"
         y="2250"
         width="447.74222"
         x="918.71436" />
      <text
         id="text2814"
         transform="matrix(0,1,-1,0,924.71433,2254)">amd_init</text>
      <rect
         id="rect2816"
         style="fill:#00ff80;fill-opacity:0.5;stroke:#000000;stroke-width:1"
         height="145"
         y="2400"
         width="33.25671"
         x="920.22827" />
      <text
         id="text2818"
         transform="matrix(0,1,-1,0,926.22829,2404)">ohci1394_init</text>
      <rect
         id="rect2820"
         style="fill:#00ff80;fill-opacity:0.5;stroke:#000000;stroke-width:1"
         height="145"
         y="1350"
         width="229.40341"
         x="1137.064" />
      <text
         id="text2822"
         transform="matrix(0,1,-1,0,1143.064,1354)">ata_generic_init</text>
      <rect
         id="rect2824"
         style="fill:#00ff80;fill-opacity:0.5;stroke:#000000;stroke-width:1"
         height="145"
         y="2550"
         width="13.784333"
         x="1343.127" />
      <text
         id="text2826"
         font-size="3pt"
         transform="matrix(0,1,-1,0,1344.127,2554)"
         style="font-size:3.75px">joydev_init</text>
      <rect
         id="rect2828"
         style="fill:#00ff80;fill-opacity:0.5;stroke:#000000;stroke-width:1"
         height="145"
         y="2700"
         width="8.4516249"
         x="1424.3721" />
      <text
         id="text2830"
         font-size="3pt"
         transform="matrix(0,1,-1,0,1425.3721,2704)"
         style="font-size:3.75px">uvc_init</text>
      <text
         id="text2832"
         transform="matrix(0,1,-1,0,0,89)">0</text>
      <text
         id="text2834"
         transform="matrix(0,1,-1,0,54.166667,89)">0.1</text>
      <text
         id="text2836"
         transform="matrix(0,1,-1,0,108.33333,89)">0.2</text>
      <text
         id="text2838"
         transform="matrix(0,1,-1,0,162.5,89)">0.3</text>
      <text
         id="text2840"
         transform="matrix(0,1,-1,0,216.66667,89)">0.4</text>
      <text
         id="text2842"
         transform="matrix(0,1,-1,0,270.83333,89)">0.5</text>
      <text
         id="text2844"
         transform="matrix(0,1,-1,0,325,89)">0.6</text>
      <text
         id="text2846"
         transform="matrix(0,1,-1,0,379.16667,89)">0.7</text>
      <text
         id="text2848"
         transform="matrix(0,1,-1,0,433.33333,89)">0.8</text>
      <text
         id="text2850"
         transform="matrix(0,1,-1,0,487.5,89)">0.89</text>
      <text
         id="text2852"
         transform="matrix(0,1,-1,0,541.66667,89)">0.99</text>
      <text
         id="text2854"
         transform="matrix(0,1,-1,0,595.83333,89)">1.09</text>
      <text
         id="text2856"
         transform="matrix(0,1,-1,0,650,89)">1.2</text>
      <text
         id="text2858"
         transform="matrix(0,1,-1,0,704.16667,89)">1.3</text>
      <text
         id="text2860"
         transform="matrix(0,1,-1,0,758.33333,89)">1.4</text>
      <text
         id="text2862"
         transform="matrix(0,1,-1,0,812.5,89)">1.5</text>
      <text
         id="text2864"
         transform="matrix(0,1,-1,0,866.66667,89)">1.6</text>
      <text
         id="text2866"
         transform="matrix(0,1,-1,0,920.83333,89)">1.7</text>
      <text
         id="text2868"
         transform="matrix(0,1,-1,0,975,89)">1.8</text>
      <text
         id="text2870"
         transform="matrix(0,1,-1,0,1029.1667,89)">1.9</text>
      <text
         id="text2872"
         transform="matrix(0,1,-1,0,1083.3333,89)">2</text>
      <text
         id="text2874"
         transform="matrix(0,1,-1,0,1137.5,89)">2.1</text>
      <text
         id="text2876"
         transform="matrix(0,1,-1,0,1191.6667,89)">2.2</text>
      <text
         id="text2878"
         transform="matrix(0,1,-1,0,1245.8333,89)">2.3</text>
      <text
         id="text2880"
         transform="matrix(0,1,-1,0,1300,89)">2.4</text>
      <text
         id="text2882"
         transform="matrix(0,1,-1,0,1354.1667,89)">2.5</text>
      <text
         id="text2884"
         transform="matrix(0,1,-1,0,1408.3333,89)">2.6</text>
      <text
         id="text2886"
         transform="matrix(0,1,-1,0,1462.5,89)">2.7</text>
      <text
         id="text2888"
         transform="matrix(0,1,-1,0,1516.6667,89)">2.8</text>
      <text
         id="text2890"
         transform="matrix(0,1,-1,0,1570.8333,89)">2.9</text>
      <text
         id="text2892"
         transform="matrix(0,1,-1,0,1625,89)">3</text>
      <text
         id="text2894"
         transform="matrix(0,1,-1,0,1679.1667,89)">3.1</text>
      <text
         id="text2896"
         transform="matrix(0,1,-1,0,1733.3333,89)">3.2</text>
      <text
         id="text2898"
         transform="matrix(0,1,-1,0,1787.5,89)">3.3</text>
      <text
         id="text2900"
         transform="matrix(0,1,-1,0,1841.6667,89)">3.4</text>
      <text
         id="text2902"
         transform="matrix(0,1,-1,0,1895.8333,89)">3.5</text>
    </g>
    <g
       id="g3262"
       transform="matrix(1,0,0,0.5185966,-584.55945,-532.42359)">
      <rect
         id="rect4"
         style="fill:#ffff80;fill-opacity:0.5;stroke:#000000;stroke-width:1"
         height="145"
         y="150"
         width="3.693625"
         x="93.499794" />
      <text
         id="text6"
         font-size="3pt"
         transform="matrix(0,1,-1,0,94.499792,154)"
         style="font-size:3.75px">acpi_init</text>
      <rect
         id="rect8"
         style="fill:#ffff80;fill-opacity:0.5;stroke:#000000;stroke-width:1"
         height="145"
         y="150"
         width="4.6865001"
         x="97.225914" />
      <text
         id="text10"
         font-size="3pt"
         transform="matrix(0,1,-1,0,98.225917,154)"
         style="font-size:3.75px">acpi_scan_init</text>
      <rect
         id="rect12"
         style="fill:#ffff80;fill-opacity:0.5;stroke:#000000;stroke-width:1"
         height="145"
         y="150"
         width="26.195541"
         x="102.05867" />
      <text
         id="text14"
         transform="matrix(0,1,-1,0,108.05867,154)">acpi_pci_root_init</text>
      <rect
         id="rect16"
         style="fill:#ffff80;fill-opacity:0.5;stroke:#000000;stroke-width:1"
         height="145"
         y="150"
         width="5.9724169"
         x="128.25421" />
      <text
         id="text18"
         font-size="3pt"
         transform="matrix(0,1,-1,0,129.25421,154)"
         style="font-size:3.75px">acpi_pci_link_init</text>
      <rect
         id="rect20"
         style="fill:#ffff80;fill-opacity:0.5;stroke:#000000;stroke-width:1"
         height="145"
         y="150"
         width="10.479625"
         x="134.69138" />
      <text
         id="text22"
         font-size="3pt"
         transform="matrix(0,1,-1,0,135.69137,154)"
         style="font-size:3.75px">genl_init</text>
      <rect
         id="rect24"
         style="fill:#ffff80;fill-opacity:0.5;stroke:#000000;stroke-width:1"
         height="145"
         y="150"
         width="3.8290417"
         x="145.67366" />
      <text
         id="text26"
         font-size="3pt"
         transform="matrix(0,1,-1,0,146.67367,154)"
         style="font-size:3.75px">hpet_late_init</text>
      <rect
         id="rect28"
         style="fill:#ffff80;fill-opacity:0.5;stroke:#000000;stroke-width:1"
         height="145"
         y="150"
         width="8.175375"
         x="150.01784" />
      <text
         id="text30"
         font-size="3pt"
         transform="matrix(0,1,-1,0,151.01783,154)"
         style="font-size:3.75px">acpi_event_init</text>
      <rect
         id="rect32"
         style="fill:#ffff80;fill-opacity:0.5;stroke:#000000;stroke-width:1"
         height="145"
         y="150"
         width="2.8708334"
         x="158.22626" />
      <text
         id="text34"
         font-size="3pt"
         transform="matrix(0,1,-1,0,159.22625,154)"
         style="font-size:3.75px">pnpacpi_init</text>
      <rect
         id="rect36"
         style="fill:#ffff80;fill-opacity:0.5;stroke:#000000;stroke-width:1"
         height="145"
         y="150"
         width="18.729208"
         x="162.4063" />
      <text
         id="text38"
         transform="matrix(0,1,-1,0,168.40629,154)">init_acpi_pm_clocksource</text>
      <rect
         id="rect40"
         style="fill:#ffff80;fill-opacity:0.5;stroke:#000000;stroke-width:1"
         height="145"
         y="150"
         width="30.995251"
         x="181.94963" />
      <text
         id="text42"
         transform="matrix(0,1,-1,0,187.94962,154)">inet_init</text>
      <rect
         id="rect44"
         style="fill:#ffff80;fill-opacity:0.5;stroke:#000000;stroke-width:1"
         height="145"
         y="150"
         width="151.42563"
         x="213.07974" />
      <text
         id="text46"
         transform="matrix(0,1,-1,0,219.07975,154)">populate_rootfs</text>
      <rect
         id="rect48"
         style="fill:#ffff80;fill-opacity:0.5;stroke:#000000;stroke-width:1"
         height="145"
         y="150"
         width="3.6665416"
         x="368.23801" />
      <text
         id="text50"
         font-size="3pt"
         transform="matrix(0,1,-1,0,369.238,154)"
         style="font-size:3.75px">init_kprobes</text>
      <rect
         id="rect52"
         style="fill:#ffff80;fill-opacity:0.5;stroke:#000000;stroke-width:1"
         height="145"
         y="150"
         width="1.8200001"
         x="373.20129" />
      <text
         id="text54"
         font-size="3pt"
         transform="matrix(0,1,-1,0,374.20129,154)"
         style="font-size:3.75px">slab_sysfs_init</text>
      <rect
         id="rect56"
         style="fill:#ffff80;fill-opacity:0.5;stroke:#000000;stroke-width:1"
         height="145"
         y="150"
         width="110.63487"
         x="379.81018" />
      <text
         id="text58"
         transform="matrix(0,1,-1,0,385.81017,154)">pci_init</text>
      <rect
         id="rect60"
         style="fill:#ffff80;fill-opacity:0.5;stroke:#000000;stroke-width:1"
         height="145"
         y="150"
         width="191.45642"
         x="491.4845" />
      <text
         id="text62"
         transform="matrix(0,1,-1,0,497.4845,154)">isapnp_init</text>
      <rect
         id="rect64"
         style="fill:#ffff80;fill-opacity:0.5;stroke:#000000;stroke-width:1"
         height="145"
         y="150"
         width="2.0707917"
         x="683.07959" />
      <text
         id="text66"
         font-size="3pt"
         transform="matrix(0,1,-1,0,684.07958,154)"
         style="font-size:3.75px">tty_init</text>
      <rect
         id="rect68"
         style="fill:#ffff80;fill-opacity:0.5;stroke:#000000;stroke-width:1"
         height="145"
         y="150"
         width="22.096209"
         x="685.18884" />
      <text
         id="text70"
         transform="matrix(0,1,-1,0,691.18883,154)">pty_init</text>
      <rect
         id="rect72"
         style="fill:#ffff80;fill-opacity:0.5;stroke:#000000;stroke-width:1"
         height="145"
         y="150"
         width="9.8301668"
         x="709.96198" />
      <text
         id="text74"
         font-size="3pt"
         transform="matrix(0,1,-1,0,710.96196,154)"
         style="font-size:3.75px">i8042_init</text>
      <rect
         id="rect76"
         style="fill:#ffff80;fill-opacity:0.5;stroke:#000000;stroke-width:1"
         height="145"
         y="150"
         width="8.8529997"
         x="719.8252" />
      <text
         id="text78"
         font-size="3pt"
         transform="matrix(0,1,-1,0,720.82517,154)"
         style="font-size:3.75px">mousedev_init</text>
      <rect
         id="rect80"
         style="fill:#ffff80;fill-opacity:0.5;stroke:#000000;stroke-width:1"
         height="145"
         y="300"
         width="2.3264582"
         x="740.91602" />
      <text
         id="text82"
         font-size="3pt"
         transform="matrix(0,1,-1,0,741.91604,304)"
         style="font-size:3.75px">fuse_init</text>
      <rect
         id="rect84"
         style="fill:#ffff80;fill-opacity:0.5;stroke:#000000;stroke-width:1"
         height="145"
         y="450"
         width="10.012709"
         x="743.23383" />
      <text
         id="text86"
         font-size="3pt"
         transform="matrix(0,1,-1,0,744.23383,454)"
         style="font-size:3.75px">acpi_processor_init</text>
      <rect
         id="rect88"
         style="fill:#ffff80;fill-opacity:0.5;stroke:#000000;stroke-width:1"
         height="145"
         y="600"
         width="3.8100834"
         x="751.62048" />
      <text
         id="text90"
         font-size="3pt"
         transform="matrix(0,1,-1,0,752.62046,604)"
         style="font-size:3.75px">init_scsi</text>
      <rect
         id="rect92"
         style="fill:#ffff80;fill-opacity:0.5;stroke:#000000;stroke-width:1"
         height="145"
         y="750"
         width="283.19254"
         x="753.39117" />
      <text
         id="text94"
         transform="matrix(0,1,-1,0,759.39117,754)">init_nic</text>
      <rect
         id="rect96"
         style="fill:#ffff80;fill-opacity:0.5;stroke:#000000;stroke-width:1"
         height="145"
         y="900"
         width="1.6829584"
         x="758.31329" />
      <text
         id="text98"
         font-size="3pt"
         transform="matrix(0,1,-1,0,759.31329,904)"
         style="font-size:3.75px">journal_init</text>
      <rect
         id="rect100"
         style="fill:#ffff80;fill-opacity:0.5;stroke:#000000;stroke-width:1"
         height="145"
         y="1050"
         width="140.153"
         x="762.9364" />
      <text
         id="text102"
         transform="matrix(0,1,-1,0,768.93642,1054)">acpi_button_init</text>
      <rect
         id="rect104"
         style="fill:#ffff80;fill-opacity:0.5;stroke:#000000;stroke-width:1"
         height="145"
         y="1200"
         width="2.2284167"
         x="763.60645" />
      <text
         id="text106"
         font-size="3pt"
         transform="matrix(0,1,-1,0,764.60646,1204)"
         style="font-size:3.75px">acpi_ac_init</text>
      <rect
         id="rect108"
         style="fill:#ffff80;fill-opacity:0.5;stroke:#000000;stroke-width:1"
         height="145"
         y="1350"
         width="2.0025418"
         x="764.43469" />
      <text
         id="text110"
         font-size="3pt"
         transform="matrix(0,1,-1,0,765.43467,1354)"
         style="font-size:3.75px">acpi_battery_init</text>
      <rect
         id="rect112"
         style="fill:#ffff80;fill-opacity:0.5;stroke:#000000;stroke-width:1"
         height="145"
         y="1500"
         width="1.873625"
         x="765.28668" />
      <text
         id="text114"
         font-size="3pt"
         transform="matrix(0,1,-1,0,766.28671,1504)"
         style="font-size:3.75px">acpi_wmi_init</text>
      <rect
         id="rect116"
         style="fill:#ffff80;fill-opacity:0.5;stroke:#000000;stroke-width:1"
         height="145"
         y="1650"
         width="37.438374"
         x="770.47156" />
      <text
         id="text118"
         transform="matrix(0,1,-1,0,776.47154,1654)">evdev_init</text>
      <rect
         id="rect120"
         style="fill:#ffff80;fill-opacity:0.5;stroke:#000000;stroke-width:1"
         height="145"
         y="1800"
         width="74.867538"
         x="770.80249" />
      <text
         id="text122"
         transform="matrix(0,1,-1,0,776.8025,1804)">pcspkr_init</text>
      <rect
         id="rect124"
         style="fill:#ffff80;fill-opacity:0.5;stroke:#000000;stroke-width:1"
         height="145"
         y="1950"
         width="262.29828"
         x="774.40131" />
      <text
         id="text126"
         transform="matrix(0,1,-1,0,780.40133,1954)">k8temp_init</text>
      <rect
         id="rect128"
         style="fill:#ffff80;fill-opacity:0.5;stroke:#000000;stroke-width:1"
         height="145"
         y="2100"
         width="77.150665"
         x="776.58643" />
      <text
         id="text130"
         transform="matrix(0,1,-1,0,782.58642,2104)">joydev_init</text>
      <rect
         id="rect132"
         style="fill:#ffff80;fill-opacity:0.5;stroke:#000000;stroke-width:1"
         height="145"
         y="2250"
         width="2.1693749"
         x="779.64465" />
      <text
         id="text134"
         font-size="3pt"
         transform="matrix(0,1,-1,0,780.64467,2254)"
         style="font-size:3.75px">ppdev_init</text>
      <rect
         id="rect136"
         style="fill:#ffff80;fill-opacity:0.5;stroke:#000000;stroke-width:1"
         height="145"
         y="2400"
         width="3.212625"
         x="782.91907" />
      <text
         id="text138"
         font-size="3pt"
         transform="matrix(0,1,-1,0,783.91904,2404)"
         style="font-size:3.75px">acpi_container_init</text>
      <rect
         id="rect140"
         style="fill:#ffff80;fill-opacity:0.5;stroke:#000000;stroke-width:1"
         height="145"
         y="2550"
         width="8.1542501"
         x="808.04102" />
      <text
         id="text142"
         font-size="3pt"
         transform="matrix(0,1,-1,0,809.041,2554)"
         style="font-size:3.75px">inet6_init</text>
      <rect
         id="rect144"
         style="fill:#ffff80;fill-opacity:0.5;stroke:#000000;stroke-width:1"
         height="145"
         y="2700"
         width="6.9983335"
         x="815.51764" />
      <text
         id="text146"
         font-size="3pt"
         transform="matrix(0,1,-1,0,816.51762,2704)"
         style="font-size:3.75px">usb_init</text>
      <rect
         id="rect148"
         style="fill:#ffff80;fill-opacity:0.5;stroke:#000000;stroke-width:1"
         height="145"
         y="2850"
         width="2.3139999"
         x="823.42542" />
      <text
         id="text150"
         font-size="3pt"
         transform="matrix(0,1,-1,0,824.42542,2854)"
         style="font-size:3.75px">powernowk8_init</text>
      <rect
         id="rect152"
         style="fill:#ffff80;fill-opacity:0.5;stroke:#000000;stroke-width:1"
         height="145"
         y="3000"
         width="447.20975"
         x="827.10876" />
      <text
         id="text154"
         transform="matrix(0,1,-1,0,833.10875,3004)">shpcd_init</text>
      <rect
         id="rect156"
         style="fill:#ffff80;fill-opacity:0.5;stroke:#000000;stroke-width:1"
         height="145"
         y="3150"
         width="3.625375"
         x="831.20752" />
      <text
         id="text158"
         font-size="3pt"
         transform="matrix(0,1,-1,0,832.20754,3154)"
         style="font-size:3.75px">parport_pc_init</text>
      <rect
         id="rect160"
         style="fill:#ffff80;fill-opacity:0.5;stroke:#000000;stroke-width:1"
         height="145"
         y="3300"
         width="2.0301666"
         x="832.4339" />
      <text
         id="text162"
         font-size="3pt"
         transform="matrix(0,1,-1,0,833.43387,3304)"
         style="font-size:3.75px">lp_init_module</text>
      <rect
         id="rect164"
         style="fill:#ffff80;fill-opacity:0.5;stroke:#000000;stroke-width:1"
         height="145"
         y="3450"
         width="2.7159166"
         x="840.24579" />
      <text
         id="text166"
         font-size="3pt"
         transform="matrix(0,1,-1,0,841.24579,3454)"
         style="font-size:3.75px">acpi_thermal_init</text>
      <rect
         id="rect168"
         style="fill:#ffff80;fill-opacity:0.5;stroke:#000000;stroke-width:1"
         height="145"
         y="3600"
         width="1.9137083"
         x="853.86438" />
      <text
         id="text170"
         font-size="3pt"
         transform="matrix(0,1,-1,0,854.86437,3604)"
         style="font-size:3.75px">ata_init</text>
      <rect
         id="rect172"
         style="fill:#ffff80;fill-opacity:0.5;stroke:#000000;stroke-width:1"
         height="145"
         y="3750"
         width="176.47176"
         x="860.68018" />
      <text
         id="text174"
         transform="matrix(0,1,-1,0,866.68017,3754)">nforce2_init</text>
      <rect
         id="rect176"
         style="fill:#ffff80;fill-opacity:0.5;stroke:#000000;stroke-width:1"
         height="145"
         y="3900"
         width="27.685125"
         x="861.68494" />
      <text
         id="text178"
         transform="matrix(0,1,-1,0,867.68496,3904)">acpi_video_init</text>
      <rect
         id="rect180"
         style="fill:#ffff80;fill-opacity:0.5;stroke:#000000;stroke-width:1"
         height="145"
         y="4050"
         width="166.26892"
         x="878.54706" />
      <text
         id="text182"
         transform="matrix(0,1,-1,0,884.54704,4054)">ehci_hcd_init</text>
      <rect
         id="rect184"
         style="fill:#ffff80;fill-opacity:0.5;stroke:#000000;stroke-width:1"
         height="145"
         y="4200"
         width="196.61417"
         x="879.76038" />
      <text
         id="text186"
         transform="matrix(0,1,-1,0,885.76037,4204)">ohci_hcd_mod_init</text>
      <rect
         id="rect188"
         style="fill:#ffff80;fill-opacity:0.5;stroke:#000000;stroke-width:1"
         height="145"
         y="4350"
         width="34.679127"
         x="881.44281" />
      <text
         id="text190"
         transform="matrix(0,1,-1,0,887.44279,4354)">ohci1394_init</text>
      <rect
         id="rect192"
         style="fill:#ffff80;fill-opacity:0.5;stroke:#000000;stroke-width:1"
         height="145"
         y="4500"
         width="192.22612"
         x="884.9306" />
      <text
         id="text194"
         transform="matrix(0,1,-1,0,890.93058,4504)">amd_init</text>
      <rect
         id="rect196"
         style="fill:#ffff80;fill-opacity:0.5;stroke:#000000;stroke-width:1"
         height="145"
         y="4650"
         width="52.042793"
         x="885.68622" />
      <text
         id="text198"
         transform="matrix(0,1,-1,0,891.68621,4654)">sdhci_drv_init</text>
      <rect
         id="rect200"
         style="fill:#ffff80;fill-opacity:0.5;stroke:#000000;stroke-width:1"
         height="145"
         y="4800"
         width="189.3932"
         x="889.32458" />
      <text
         id="text202"
         transform="matrix(0,1,-1,0,895.32458,4804)">nv_init</text>
      <rect
         id="rect204"
         style="fill:#ffff80;fill-opacity:0.5;stroke:#000000;stroke-width:1"
         height="145"
         y="4950"
         width="383.85641"
         x="890.42957" />
      <text
         id="text206"
         transform="matrix(0,1,-1,0,896.42958,4954)">ata_generic_init</text>
      <rect
         id="rect208"
         style="fill:#ffff80;fill-opacity:0.5;stroke:#000000;stroke-width:1"
         height="145"
         y="5100"
         width="382.96701"
         x="891.47284" />
      <text
         id="text210"
         transform="matrix(0,1,-1,0,897.47283,5104)">pacpi_init</text>
      <rect
         id="rect212"
         style="fill:#ffff80;fill-opacity:0.5;stroke:#000000;stroke-width:1"
         height="145"
         y="5250"
         width="336.55539"
         x="937.62122" />
      <text
         id="text214"
         transform="matrix(0,1,-1,0,943.62121,5254)">alsa_card_azx_init</text>
      <rect
         id="rect216"
         style="fill:#ffff80;fill-opacity:0.5;stroke:#000000;stroke-width:1"
         height="145"
         y="5400"
         width="1.9700416"
         x="939.23431" />
      <text
         id="text218"
         font-size="3pt"
         transform="matrix(0,1,-1,0,940.23429,5404)"
         style="font-size:3.75px">alsa_seq_oss_init</text>
      <text
         id="text220"
         transform="matrix(0,1,-1,0,0,89)">0</text>
      <text
         id="text222"
         transform="matrix(0,1,-1,0,54.166667,89)">0.1</text>
      <text
         id="text224"
         transform="matrix(0,1,-1,0,108.33333,89)">0.2</text>
      <text
         id="text226"
         transform="matrix(0,1,-1,0,162.5,89)">0.3</text>
      <text
         id="text228"
         transform="matrix(0,1,-1,0,216.66667,89)">0.4</text>
      <text
         id="text230"
         transform="matrix(0,1,-1,0,270.83333,89)">0.5</text>
      <text
         id="text232"
         transform="matrix(0,1,-1,0,325,89)">0.6</text>
      <text
         id="text234"
         transform="matrix(0,1,-1,0,379.16667,89)">0.7</text>
      <text
         id="text236"
         transform="matrix(0,1,-1,0,433.33333,89)">0.8</text>
      <text
         id="text238"
         transform="matrix(0,1,-1,0,487.5,89)">0.89</text>
      <text
         id="text240"
         transform="matrix(0,1,-1,0,541.66667,89)">0.99</text>
      <text
         id="text242"
         transform="matrix(0,1,-1,0,595.83333,89)">1.09</text>
      <text
         id="text244"
         transform="matrix(0,1,-1,0,650,89)">1.2</text>
      <text
         id="text246"
         transform="matrix(0,1,-1,0,704.16667,89)">1.3</text>
      <text
         id="text248"
         transform="matrix(0,1,-1,0,758.33333,89)">1.4</text>
      <text
         id="text250"
         transform="matrix(0,1,-1,0,812.5,89)">1.5</text>
      <text
         id="text252"
         transform="matrix(0,1,-1,0,866.66667,89)">1.6</text>
      <text
         id="text254"
         transform="matrix(0,1,-1,0,920.83333,89)">1.7</text>
      <text
         id="text256"
         transform="matrix(0,1,-1,0,975,89)">1.8</text>
      <text
         id="text258"
         transform="matrix(0,1,-1,0,1029.1667,89)">1.9</text>
      <text
         id="text260"
         transform="matrix(0,1,-1,0,1083.3333,89)">2</text>
      <text
         id="text262"
         transform="matrix(0,1,-1,0,1137.5,89)">2.1</text>
      <text
         id="text264"
         transform="matrix(0,1,-1,0,1191.6667,89)">2.2</text>
      <text
         id="text266"
         transform="matrix(0,1,-1,0,1245.8333,89)">2.3</text>
      <text
         id="text268"
         transform="matrix(0,1,-1,0,1300,89)">2.4</text>
      <text
         id="text270"
         transform="matrix(0,1,-1,0,1354.1667,89)">2.5</text>
      <text
         id="text272"
         transform="matrix(0,1,-1,0,1408.3333,89)">2.6</text>
      <text
         id="text274"
         transform="matrix(0,1,-1,0,1462.5,89)">2.7</text>
      <text
         id="text276"
         transform="matrix(0,1,-1,0,1516.6667,89)">2.8</text>
      <text
         id="text278"
         transform="matrix(0,1,-1,0,1570.8333,89)">2.9</text>
      <text
         id="text280"
         transform="matrix(0,1,-1,0,1625,89)">3</text>
      <text
         id="text282"
         transform="matrix(0,1,-1,0,1679.1667,89)">3.1</text>
      <text
         id="text284"
         transform="matrix(0,1,-1,0,1733.3333,89)">3.2</text>
      <text
         id="text286"
         transform="matrix(0,1,-1,0,1787.5,89)">3.3</text>
      <text
         id="text288"
         transform="matrix(0,1,-1,0,1841.6667,89)">3.4</text>
      <text
         id="text290"
         transform="matrix(0,1,-1,0,1895.8333,89)">3.5</text>
    </g>
    <g
       id="g2624"
       transform="translate(-572.70014,-511.11887)">
      <g
         id="g2542">
        <rect
           x="93.765747"
           width="3.674125"
           y="150"
           height="145"
           style="fill:#ff80ff;fill-opacity:0.5;stroke:#000000;stroke-width:1"
           id="rect3091" />
        <text
           transform="matrix(0,1,-1,0,94.76575,154)"
           font-size="3pt"
           id="text3094"
           style="font-size:3.75px">acpi_init</text>
        <rect
           x="97.472374"
           width="4.4590001"
           y="150"
           height="145"
           style="fill:#ff80ff;fill-opacity:0.5;stroke:#000000;stroke-width:1"
           id="rect3096" />
        <text
           transform="matrix(0,1,-1,0,98.472375,154)"
           font-size="3pt"
           id="text3098"
           style="font-size:3.75px">acpi_scan_init</text>
        <rect
           x="101.93137"
           width="2.0745833"
           y="150"
           height="145"
           style="fill:#ff80ff;fill-opacity:0.5;stroke:#000000;stroke-width:1"
           id="rect3100" />
        <text
           transform="matrix(0,1,-1,0,102.93138,154)"
           font-size="3pt"
           id="text3102"
           style="font-size:3.75px">acpi_ec_init</text>
        <rect
           x="104.21938"
           width="24.482792"
           y="150"
           height="145"
           style="fill:#ff80ff;fill-opacity:0.5;stroke:#000000;stroke-width:1"
           id="rect3104" />
        <text
           transform="matrix(0,1,-1,0,110.21938,154)"
           id="text3106">acpi_pci_root_init</text>
        <rect
           x="128.70216"
           width="5.6365833"
           y="150"
           height="145"
           style="fill:#ff80ff;fill-opacity:0.5;stroke:#000000;stroke-width:1"
           id="rect3108" />
        <text
           transform="matrix(0,1,-1,0,129.70217,154)"
           font-size="3pt"
           id="text3110"
           style="font-size:3.75px">acpi_pci_link_init</text>
        <rect
           x="134.65562"
           width="10.515917"
           y="150"
           height="145"
           style="fill:#ff80ff;fill-opacity:0.5;stroke:#000000;stroke-width:1"
           id="rect3112" />
        <text
           transform="matrix(0,1,-1,0,135.65562,154)"
           font-size="3pt"
           id="text3114"
           style="font-size:3.75px">genl_init</text>
        <rect
           x="145.26849"
           width="2.07025"
           y="150"
           height="145"
           style="fill:#ff80ff;fill-opacity:0.5;stroke:#000000;stroke-width:1"
           id="rect3116" />
        <text
           transform="matrix(0,1,-1,0,146.2685,154)"
           font-size="3pt"
           id="text3118"
           style="font-size:3.75px">atm_init</text>
        <rect
           x="147.82138"
           width="1.6856667"
           y="150"
           height="145"
           style="fill:#ff80ff;fill-opacity:0.5;stroke:#000000;stroke-width:1"
           id="rect3120" />
        <text
           transform="matrix(0,1,-1,0,148.82137,154)"
           font-size="3pt"
           id="text3122"
           style="font-size:3.75px">hpet_late_init</text>
        <rect
           x="150.01837"
           width="6.5482082"
           y="150"
           height="145"
           style="fill:#ff80ff;fill-opacity:0.5;stroke:#000000;stroke-width:1"
           id="rect3124" />
        <text
           transform="matrix(0,1,-1,0,151.01837,154)"
           font-size="3pt"
           id="text3126"
           style="font-size:3.75px">acpi_event_init</text>
        <rect
           x="156.59962"
           width="2.7375834"
           y="150"
           height="145"
           style="fill:#ff80ff;fill-opacity:0.5;stroke:#000000;stroke-width:1"
           id="rect3128" />
        <text
           transform="matrix(0,1,-1,0,157.59962,154)"
           font-size="3pt"
           id="text3130"
           style="font-size:3.75px">pnpacpi_init</text>
        <rect
           x="160.64371"
           width="18.730291"
           y="150"
           height="145"
           style="fill:#ff80ff;fill-opacity:0.5;stroke:#000000;stroke-width:1"
           id="rect3132" />
        <text
           transform="matrix(0,1,-1,0,166.64371,154)"
           id="text3134">init_acpi_pm_clocksource</text>
        <rect
           x="180.19571"
           width="30.581417"
           y="150"
           height="145"
           style="fill:#ff80ff;fill-opacity:0.5;stroke:#000000;stroke-width:1"
           id="rect3136" />
        <text
           transform="matrix(0,1,-1,0,186.19571,154)"
           id="text3138">inet_init</text>
        <rect
           x="210.91309"
           width="140.27434"
           y="150"
           height="145"
           style="fill:#ff80ff;fill-opacity:0.5;stroke:#000000;stroke-width:1"
           id="rect3140" />
        <text
           transform="matrix(0,1,-1,0,216.91308,154)"
           id="text3142">populate_rootfs</text>
        <rect
           x="354.92004"
           width="3.6773751"
           y="150"
           height="145"
           style="fill:#ff80ff;fill-opacity:0.5;stroke:#000000;stroke-width:1"
           id="rect3144" />
        <text
           transform="matrix(0,1,-1,0,355.92004,154)"
           font-size="3pt"
           id="text3146"
           style="font-size:3.75px">init_kprobes</text>
        <rect
           x="359.8996"
           width="1.8129584"
           y="150"
           height="145"
           style="fill:#ff80ff;fill-opacity:0.5;stroke:#000000;stroke-width:1"
           id="rect3148" />
        <text
           transform="matrix(0,1,-1,0,360.89958,154)"
           font-size="3pt"
           id="text3150"
           style="font-size:3.75px">slab_sysfs_init</text>
        <rect
           x="366.44888"
           width="110.99617"
           y="150"
           height="145"
           style="fill:#ff80ff;fill-opacity:0.5;stroke:#000000;stroke-width:1"
           id="rect3152" />
        <text
           transform="matrix(0,1,-1,0,372.44887,154)"
           id="text3154">pci_init</text>
        <rect
           x="478.48828"
           width="191.46454"
           y="150"
           height="145"
           style="fill:#ff80ff;fill-opacity:0.5;stroke:#000000;stroke-width:1"
           id="rect3156" />
        <text
           transform="matrix(0,1,-1,0,484.48829,154)"
           id="text3158">isapnp_init</text>
        <rect
           x="670.09204"
           width="2.0745833"
           y="150"
           height="145"
           style="fill:#ff80ff;fill-opacity:0.5;stroke:#000000;stroke-width:1"
           id="rect3160" />
        <text
           transform="matrix(0,1,-1,0,671.09204,154)"
           font-size="3pt"
           id="text3162"
           style="font-size:3.75px">tty_init</text>
        <rect
           x="672.20508"
           width="22.298792"
           y="150"
           height="145"
           style="fill:#ff80ff;fill-opacity:0.5;stroke:#000000;stroke-width:1"
           id="rect3164" />
        <text
           transform="matrix(0,1,-1,0,678.20508,154)"
           id="text3166">pty_init</text>
        <rect
           x="697.28479"
           width="9.4407082"
           y="150"
           height="145"
           style="fill:#ff80ff;fill-opacity:0.5;stroke:#000000;stroke-width:1"
           id="rect3168" />
        <text
           transform="matrix(0,1,-1,0,698.28479,154)"
           font-size="3pt"
           id="text3170"
           style="font-size:3.75px">i8042_init</text>
        <rect
           x="706.75854"
           width="11.0825"
           y="150"
           height="145"
           style="fill:#ff80ff;fill-opacity:0.5;stroke:#000000;stroke-width:1"
           id="rect3172" />
        <text
           transform="matrix(0,1,-1,0,707.75854,154)"
           font-size="3pt"
           id="text3174"
           style="font-size:3.75px">mousedev_init</text>
        <rect
           x="829.28357"
           width="516.58698"
           y="300"
           height="145"
           style="fill:#ff80ff;fill-opacity:0.5;stroke:#000000;stroke-width:1"
           id="rect3176" />
        <text
           transform="matrix(0,1,-1,0,835.28354,304)"
           id="text3178">init_megamodule</text>
        <text
           transform="matrix(0,1,-1,0,0,89)"
           id="text92">0</text>
        <text
           transform="matrix(0,1,-1,0,54.166667,89)"
           id="text3181">0.1</text>
        <text
           transform="matrix(0,1,-1,0,108.33333,89)"
           id="text96">0.2</text>
        <text
           transform="matrix(0,1,-1,0,162.5,89)"
           id="text3184">0.3</text>
        <text
           transform="matrix(0,1,-1,0,216.66667,89)"
           id="text100">0.4</text>
        <text
           transform="matrix(0,1,-1,0,270.83333,89)"
           id="text3187">0.5</text>
        <text
           transform="matrix(0,1,-1,0,325,89)"
           id="text104">0.6</text>
        <text
           transform="matrix(0,1,-1,0,379.16667,89)"
           id="text3190">0.7</text>
        <text
           transform="matrix(0,1,-1,0,433.33333,89)"
           id="text108">0.8</text>
        <text
           transform="matrix(0,1,-1,0,487.5,89)"
           id="text3193">0.89</text>
        <text
           transform="matrix(0,1,-1,0,541.66667,89)"
           id="text112">0.99</text>
        <text
           transform="matrix(0,1,-1,0,595.83333,89)"
           id="text3196">1.09</text>
        <text
           transform="matrix(0,1,-1,0,650,89)"
           id="text116">1.2</text>
        <text
           transform="matrix(0,1,-1,0,704.16667,89)"
           id="text3199">1.3</text>
        <text
           transform="matrix(0,1,-1,0,758.33333,89)"
           id="text120">1.4</text>
        <text
           transform="matrix(0,1,-1,0,812.5,89)"
           id="text3202">1.5</text>
        <text
           transform="matrix(0,1,-1,0,866.66667,89)"
           id="text124">1.6</text>
        <text
           transform="matrix(0,1,-1,0,920.83333,89)"
           id="text3205">1.7</text>
        <text
           transform="matrix(0,1,-1,0,975,89)"
           id="text128">1.8</text>
        <text
           transform="matrix(0,1,-1,0,1029.1667,89)"
           id="text3208">1.9</text>
        <text
           transform="matrix(0,1,-1,0,1083.3333,89)"
           id="text132">2</text>
        <text
           transform="matrix(0,1,-1,0,1137.5,89)"
           id="text3211">2.1</text>
        <text
           transform="matrix(0,1,-1,0,1191.6667,89)"
           id="text136">2.2</text>
        <text
           transform="matrix(0,1,-1,0,1245.8333,89)"
           id="text3214">2.3</text>
        <text
           transform="matrix(0,1,-1,0,1300,89)"
           id="text140">2.4</text>
        <text
           transform="matrix(0,1,-1,0,1354.1667,89)"
           id="text3217">2.5</text>
        <text
           transform="matrix(0,1,-1,0,1408.3333,89)"
           id="text144">2.6</text>
        <text
           transform="matrix(0,1,-1,0,1462.5,89)"
           id="text3220">2.7</text>
        <text
           transform="matrix(0,1,-1,0,1516.6667,89)"
           id="text148">2.8</text>
        <text
           transform="matrix(0,1,-1,0,1570.8333,89)"
           id="text3223">2.9</text>
        <text
           transform="matrix(0,1,-1,0,1625,89)"
           id="text152">3</text>
        <text
           transform="matrix(0,1,-1,0,1679.1667,89)"
           id="text3226">3.1</text>
        <text
           transform="matrix(0,1,-1,0,1733.3333,89)"
           id="text156">3.2</text>
        <text
           transform="matrix(0,1,-1,0,1787.5,89)"
           id="text3229">3.3</text>
        <text
           transform="matrix(0,1,-1,0,1841.6667,89)"
           id="text160">3.4</text>
        <text
           transform="matrix(0,1,-1,0,1895.8333,89)"
           id="text3232">3.5</text>
      </g>
    </g>
  </g>
</svg>

--=-gtK0ijxj+2IqmfStKzyo--

