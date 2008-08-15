Return-Path: <linux-kernel-owner+w=401wt.eu-S1761450AbYHOWB6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761450AbYHOWB6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2008 18:01:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754375AbYHOWBr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Aug 2008 18:01:47 -0400
Received: from py-out-1112.google.com ([64.233.166.176]:8997 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761273AbYHOWBp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2008 18:01:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:references;
        b=JlDwVXTGpPemfsRgDiyRNQXyk4akrtvbVmdXC/y3t7PFRub+28dVgsAl7w7AduCOMq
         wXYI9TuZrxwntf4yht6MQTpgvL82Z38VuPM8TqUVbjfB/SrFI3wSk5nPc/hyM8x2wK2l
         O5/7xMgYtYJAWfbgJvjL+ojgj/C7K0hVpyMcw=
Message-ID: <6278d2220808151501i207e5cccg733e20b8fa1d227d@mail.gmail.com>
Date: Fri, 15 Aug 2008 23:01:42 +0100
From: "Daniel J Blueman" <daniel.blueman@gmail.com>
To: "Takashi Iwai" <tiwai@suse.de>
Subject: Re: ALC883 recording troubles...
Cc: "Vegard Nossum" <vegard.nossum@gmail.com>,
       "Romano Giannetti" <romano@dea.icai.upcomillas.es>,
       "Linux Kernel" <linux-kernel@vger.kernel.org>
In-Reply-To: <s5hfxp65ohr.wl%tiwai@suse.de>
MIME-Version: 1.0
Content-Type: multipart/mixed; 
	boundary="----=_Part_66627_5323877.1218837702892"
References: <6278d2220806091259t47c9b070v269da0f5855ef014@mail.gmail.com>
	 <s5habhtesoq.wl%tiwai@suse.de>
	 <6278d2220806111200g4f802885wfc5f0fd6c0405efb@mail.gmail.com>
	 <s5hiqwf0vyr.wl%tiwai@suse.de>
	 <6278d2220806271705v5bd5fec3l86c3560283063092@mail.gmail.com>
	 <19f34abd0806280311s115062e6vc6d0f304cb744934@mail.gmail.com>
	 <6278d2220806280329j2f77c52dp8fbae78420c136c1@mail.gmail.com>
	 <6278d2220808141210p3c612feen6fe779bc84a4ae78@mail.gmail.com>
	 <s5hfxp65ohr.wl%tiwai@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

------=_Part_66627_5323877.1218837702892
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hi Takashi,

On Fri, Aug 15, 2008 at 3:42 PM, Takashi Iwai <tiwai@suse.de> wrote:
> At Thu, 14 Aug 2008 20:10:03 +0100,
> Daniel J Blueman wrote:
>>
>> Hi Takashi,
>>
>> I am still finding this recording +ve saturation on my ALC883 Intel
>> HDA sound device with 2.6.27-rc3 (ie ALSA 1.0.17 drivers) and ALSA
>> 1.0.16-1 libraries on Ubuntu Intrepid.
>>
>> The previous workaround still 'gets us out of jail':
>>
>> # ./hda-verb /dev/snd/hwC0D0 0x23 SET_AMP_GAIN_MUTE 0x7180
>> nid = 0x23, verb = 0x300, param = 0x7180
>> value = 0x0
>
> Could you try the patch below?  With this patch, unused connections
> will be disabled.  Let me know if it really works so that I can merge
> it to git tree.
>
> Takashi
>
> ---
> diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
> index 9473abb..6f0485a 100644
> --- a/sound/pci/hda/patch_realtek.c
> +++ b/sound/pci/hda/patch_realtek.c
> @@ -6442,6 +6442,40 @@ static void alc882_auto_init_analog_input(struct hda_codec *codec)
>        }
>  }
>
> +static void alc882_auto_init_input_src(struct hda_codec *codec)
> +{
> +       struct alc_spec *spec = codec->spec;
> +       const struct hda_input_mux *imux = spec->input_mux;
> +       int c;
> +
> +       for (c = 0; c < spec->num_adc_nids; c++) {
> +               hda_nid_t conn_list[10];
> +               hda_nid_t nid = spec->capsrc_nids[c];
> +               int conns, mute, idx, item;
> +
> +               conns = snd_hda_get_connections(codec, nid, conn_list,
> +                                               ARRAY_SIZE(conn_list));
> +               if (conns < 0)
> +                       continue;
> +               mute = HDA_AMP_MUTE;
> +               for (idx = 0; idx < conns; idx++) {
> +                       /* if the current connection is the selected one,
> +                        * unmute it as default - otherwise mute it
> +                        */
> +                       for (item = 0; item < imux->num_items; item++) {
> +                               if (imux->items[item].index == idx) {
> +                                       if (spec->cur_mux[c] == item)
> +                                               mute = 0;
> +                                       break;
> +                               }
> +                       }
> +                       snd_hda_codec_amp_stereo(codec, nid, HDA_INPUT,
> +                                                idx, HDA_AMP_MUTE, mute);
> +               }
> +
> +       }
> +}
> +
>  /* add mic boosts if needed */
>  static int alc_auto_add_mic_boost(struct hda_codec *codec)
>  {
> @@ -6496,6 +6530,7 @@ static void alc882_auto_init(struct hda_codec *codec)
>        alc882_auto_init_multi_out(codec);
>        alc882_auto_init_hp_out(codec);
>        alc882_auto_init_analog_input(codec);
> +       alc882_auto_init_input_src(codec);
>        if (spec->unsol_event)
>                alc_sku_automute(codec);
>  }
> @@ -8290,6 +8325,8 @@ static void alc883_auto_init_analog_input(struct hda_codec *codec)
>        }
>  }
>
> +#define alc883_auto_init_input_src     alc882_auto_init_input_src
> +
>  /* almost identical with ALC880 parser... */
>  static int alc883_parse_auto_config(struct hda_codec *codec)
>  {
> @@ -8320,6 +8357,7 @@ static void alc883_auto_init(struct hda_codec *codec)
>        alc883_auto_init_multi_out(codec);
>        alc883_auto_init_hp_out(codec);
>        alc883_auto_init_analog_input(codec);
> +       alc883_auto_init_input_src(codec);
>        if (spec->unsol_event)
>                alc_sku_automute(codec);
>  }
> @@ -9703,6 +9741,7 @@ static int alc262_parse_auto_config(struct hda_codec *codec)
>  #define alc262_auto_init_multi_out     alc882_auto_init_multi_out
>  #define alc262_auto_init_hp_out                alc882_auto_init_hp_out
>  #define alc262_auto_init_analog_input  alc882_auto_init_analog_input
> +#define alc262_auto_init_input_src     alc882_auto_init_input_src
>
>
>  /* init callback for auto-configuration model -- overriding the default init */
> @@ -9712,6 +9751,7 @@ static void alc262_auto_init(struct hda_codec *codec)
>        alc262_auto_init_multi_out(codec);
>        alc262_auto_init_hp_out(codec);
>        alc262_auto_init_analog_input(codec);
> +       alc262_auto_init_input_src(codec);
>        if (spec->unsol_event)
>                alc_sku_automute(codec);
>  }
> @@ -13382,6 +13422,8 @@ static void alc861vd_auto_init_analog_input(struct hda_codec *codec)
>        }
>  }
>
> +#define alc861vd_auto_init_input_src   alc882_auto_init_input_src
> +
>  #define alc861vd_idx_to_mixer_vol(nid)         ((nid) + 0x02)
>  #define alc861vd_idx_to_mixer_switch(nid)      ((nid) + 0x0c)
>
> @@ -13564,6 +13606,7 @@ static void alc861vd_auto_init(struct hda_codec *codec)
>        alc861vd_auto_init_multi_out(codec);
>        alc861vd_auto_init_hp_out(codec);
>        alc861vd_auto_init_analog_input(codec);
> +       alc861vd_auto_init_input_src(codec);
>        if (spec->unsol_event)
>                alc_sku_automute(codec);
>  }
> @@ -14729,6 +14772,8 @@ static void alc662_auto_init_analog_input(struct hda_codec *codec)
>        }
>  }
>
> +#define alc662_auto_init_input_src     alc882_auto_init_input_src
> +
>  static int alc662_parse_auto_config(struct hda_codec *codec)
>  {
>        struct alc_spec *spec = codec->spec;
> @@ -14785,6 +14830,7 @@ static void alc662_auto_init(struct hda_codec *codec)
>        alc662_auto_init_multi_out(codec);
>        alc662_auto_init_hp_out(codec);
>        alc662_auto_init_analog_input(codec);
> +       alc662_auto_init_input_src(codec);
>        if (spec->unsol_event)
>                alc_sku_automute(codec);
>  }

There were a couple of issues: getting the mute logic right from
moving the assignment and increasing the number of inputs beyond the
11 required here to avoid the 'Too many connections' message and
fixing the last input being skipped.

With the updated patch, the problem is fully addressed; no resulting
DC offset, so recording quality is great. This seems logically safe
and a hopeful for 2.6.27-rc4...

The updated patch is against 2.6.27-rc3.

Thanks once again,
  Daniel

Signed-off-by: Daniel J Blueman <daniel.blueman@gmail.com>
-- 
Daniel J Blueman

------=_Part_66627_5323877.1218837702892
Content-Type: text/x-patch; name=alc-input-muting.patch
Content-Transfer-Encoding: base64
X-Attachment-Id: f_fjxc5i380
Content-Disposition: attachment; filename=alc-input-muting.patch

ZGlmZiAtLWdpdCBhL3NvdW5kL3BjaS9oZGEvcGF0Y2hfcmVhbHRlay5jIGIvc291bmQvcGNpL2hk
YS9wYXRjaF9yZWFsdGVrLmMKaW5kZXggYWRkNGU4Ny4uMjY3NzliNyAxMDA2NDQKLS0tIGEvc291
bmQvcGNpL2hkYS9wYXRjaF9yZWFsdGVrLmMKKysrIGIvc291bmQvcGNpL2hkYS9wYXRjaF9yZWFs
dGVrLmMKQEAgLTY0MzcsNiArNjQzNywzOSBAQCBzdGF0aWMgdm9pZCBhbGM4ODJfYXV0b19pbml0
X2FuYWxvZ19pbnB1dChzdHJ1Y3QgaGRhX2NvZGVjICpjb2RlYykKIAl9CiB9CiAKK3N0YXRpYyB2
b2lkIGFsYzg4Ml9hdXRvX2luaXRfaW5wdXRfc3JjKHN0cnVjdCBoZGFfY29kZWMgKmNvZGVjKQor
eworCXN0cnVjdCBhbGNfc3BlYyAqc3BlYyA9IGNvZGVjLT5zcGVjOworCWNvbnN0IHN0cnVjdCBo
ZGFfaW5wdXRfbXV4ICppbXV4ID0gc3BlYy0+aW5wdXRfbXV4OworCWludCBjOworCisJZm9yIChj
ID0gMDsgYyA8IHNwZWMtPm51bV9hZGNfbmlkczsgYysrKSB7CisJCWhkYV9uaWRfdCBjb25uX2xp
c3RbSERBX01BWF9OVU1fSU5QVVRTXTsKKwkJaGRhX25pZF90IG5pZCA9IHNwZWMtPmNhcHNyY19u
aWRzW2NdOworCQlpbnQgY29ubnMsIG11dGUsIGlkeCwgaXRlbTsKKworCQljb25ucyA9IHNuZF9o
ZGFfZ2V0X2Nvbm5lY3Rpb25zKGNvZGVjLCBuaWQsIGNvbm5fbGlzdCwKKwkJCQkJCUFSUkFZX1NJ
WkUoY29ubl9saXN0KSk7CisJCWlmIChjb25ucyA8IDApCisJCQljb250aW51ZTsKKwkJZm9yIChp
ZHggPSAwOyBpZHggPCBjb25uczsgaWR4KyspIHsKKwkJCS8qIGlmIHRoZSBjdXJyZW50IGNvbm5l
Y3Rpb24gaXMgdGhlIHNlbGVjdGVkIG9uZSwKKwkJCSAqIHVubXV0ZSBpdCBhcyBkZWZhdWx0IC0g
b3RoZXJ3aXNlIG11dGUgaXQKKwkJCSAqLworCQkJbXV0ZSA9IEhEQV9BTVBfTVVURTsKKwkJCWZv
ciAoaXRlbSA9IDA7IGl0ZW0gPCBpbXV4LT5udW1faXRlbXM7IGl0ZW0rKykgeworCQkJCWlmIChp
bXV4LT5pdGVtc1tpdGVtXS5pbmRleCA9PSBpZHgpIHsKKwkJCQkJaWYgKHNwZWMtPmN1cl9tdXhb
Y10gPT0gaXRlbSkKKwkJCQkJCW11dGUgPSAwOworCQkJCQkJYnJlYWs7CisJCQkJfQorCQkJfQor
CQkJc25kX2hkYV9jb2RlY19hbXBfc3RlcmVvKGNvZGVjLCBuaWQsIEhEQV9JTlBVVCwKKwkJCQkJ
CWlkeCwgSERBX0FNUF9NVVRFLCBtdXRlKTsKKwkJfQorCX0KK30KKwogLyogYWRkIG1pYyBib29z
dHMgaWYgbmVlZGVkICovCiBzdGF0aWMgaW50IGFsY19hdXRvX2FkZF9taWNfYm9vc3Qoc3RydWN0
IGhkYV9jb2RlYyAqY29kZWMpCiB7CkBAIC02NDkxLDYgKzY1MjQsNyBAQCBzdGF0aWMgdm9pZCBh
bGM4ODJfYXV0b19pbml0KHN0cnVjdCBoZGFfY29kZWMgKmNvZGVjKQogCWFsYzg4Ml9hdXRvX2lu
aXRfbXVsdGlfb3V0KGNvZGVjKTsKIAlhbGM4ODJfYXV0b19pbml0X2hwX291dChjb2RlYyk7CiAJ
YWxjODgyX2F1dG9faW5pdF9hbmFsb2dfaW5wdXQoY29kZWMpOworCWFsYzg4Ml9hdXRvX2luaXRf
aW5wdXRfc3JjKGNvZGVjKTsKIAlpZiAoc3BlYy0+dW5zb2xfZXZlbnQpCiAJCWFsY19za3VfYXV0
b211dGUoY29kZWMpOwogfQpAQCAtODI4NSw2ICs4MzE5LDggQEAgc3RhdGljIHZvaWQgYWxjODgz
X2F1dG9faW5pdF9hbmFsb2dfaW5wdXQoc3RydWN0IGhkYV9jb2RlYyAqY29kZWMpCiAJfQogfQog
CisjZGVmaW5lIGFsYzg4M19hdXRvX2luaXRfaW5wdXRfc3JjCWFsYzg4Ml9hdXRvX2luaXRfaW5w
dXRfc3JjCisKIC8qIGFsbW9zdCBpZGVudGljYWwgd2l0aCBBTEM4ODAgcGFyc2VyLi4uICovCiBz
dGF0aWMgaW50IGFsYzg4M19wYXJzZV9hdXRvX2NvbmZpZyhzdHJ1Y3QgaGRhX2NvZGVjICpjb2Rl
YykKIHsKQEAgLTgzMTUsNiArODM1MSw3IEBAIHN0YXRpYyB2b2lkIGFsYzg4M19hdXRvX2luaXQo
c3RydWN0IGhkYV9jb2RlYyAqY29kZWMpCiAJYWxjODgzX2F1dG9faW5pdF9tdWx0aV9vdXQoY29k
ZWMpOwogCWFsYzg4M19hdXRvX2luaXRfaHBfb3V0KGNvZGVjKTsKIAlhbGM4ODNfYXV0b19pbml0
X2FuYWxvZ19pbnB1dChjb2RlYyk7CisJYWxjODgzX2F1dG9faW5pdF9pbnB1dF9zcmMoY29kZWMp
OwogCWlmIChzcGVjLT51bnNvbF9ldmVudCkKIAkJYWxjX3NrdV9hdXRvbXV0ZShjb2RlYyk7CiB9
CkBAIC05NjYzLDYgKzk3MDAsNyBAQCBzdGF0aWMgaW50IGFsYzI2Ml9wYXJzZV9hdXRvX2NvbmZp
ZyhzdHJ1Y3QgaGRhX2NvZGVjICpjb2RlYykKICNkZWZpbmUgYWxjMjYyX2F1dG9faW5pdF9tdWx0
aV9vdXQJYWxjODgyX2F1dG9faW5pdF9tdWx0aV9vdXQKICNkZWZpbmUgYWxjMjYyX2F1dG9faW5p
dF9ocF9vdXQJCWFsYzg4Ml9hdXRvX2luaXRfaHBfb3V0CiAjZGVmaW5lIGFsYzI2Ml9hdXRvX2lu
aXRfYW5hbG9nX2lucHV0CWFsYzg4Ml9hdXRvX2luaXRfYW5hbG9nX2lucHV0CisjZGVmaW5lIGFs
YzI2Ml9hdXRvX2luaXRfaW5wdXRfc3JjICAgICBhbGM4ODJfYXV0b19pbml0X2lucHV0X3NyYwog
CiAKIC8qIGluaXQgY2FsbGJhY2sgZm9yIGF1dG8tY29uZmlndXJhdGlvbiBtb2RlbCAtLSBvdmVy
cmlkaW5nIHRoZSBkZWZhdWx0IGluaXQgKi8KQEAgLTk2NzIsNiArOTcxMCw3IEBAIHN0YXRpYyB2
b2lkIGFsYzI2Ml9hdXRvX2luaXQoc3RydWN0IGhkYV9jb2RlYyAqY29kZWMpCiAJYWxjMjYyX2F1
dG9faW5pdF9tdWx0aV9vdXQoY29kZWMpOwogCWFsYzI2Ml9hdXRvX2luaXRfaHBfb3V0KGNvZGVj
KTsKIAlhbGMyNjJfYXV0b19pbml0X2FuYWxvZ19pbnB1dChjb2RlYyk7CisJYWxjMjYyX2F1dG9f
aW5pdF9pbnB1dF9zcmMoY29kZWMpOwogCWlmIChzcGVjLT51bnNvbF9ldmVudCkKIAkJYWxjX3Nr
dV9hdXRvbXV0ZShjb2RlYyk7CiB9CkBAIC0xMzMzMCw2ICsxMzM2OSw4IEBAIHN0YXRpYyB2b2lk
IGFsYzg2MXZkX2F1dG9faW5pdF9hbmFsb2dfaW5wdXQoc3RydWN0IGhkYV9jb2RlYyAqY29kZWMp
CiAJfQogfQogCisjZGVmaW5lIGFsYzg2MXZkX2F1dG9faW5pdF9pbnB1dF9zcmMgICBhbGM4ODJf
YXV0b19pbml0X2lucHV0X3NyYworCiAjZGVmaW5lIGFsYzg2MXZkX2lkeF90b19taXhlcl92b2wo
bmlkKQkJKChuaWQpICsgMHgwMikKICNkZWZpbmUgYWxjODYxdmRfaWR4X3RvX21peGVyX3N3aXRj
aChuaWQpCSgobmlkKSArIDB4MGMpCiAKQEAgLTEzNTEyLDYgKzEzNTUzLDcgQEAgc3RhdGljIHZv
aWQgYWxjODYxdmRfYXV0b19pbml0KHN0cnVjdCBoZGFfY29kZWMgKmNvZGVjKQogCWFsYzg2MXZk
X2F1dG9faW5pdF9tdWx0aV9vdXQoY29kZWMpOwogCWFsYzg2MXZkX2F1dG9faW5pdF9ocF9vdXQo
Y29kZWMpOwogCWFsYzg2MXZkX2F1dG9faW5pdF9hbmFsb2dfaW5wdXQoY29kZWMpOworCWFsYzg2
MXZkX2F1dG9faW5pdF9pbnB1dF9zcmMoY29kZWMpOwogCWlmIChzcGVjLT51bnNvbF9ldmVudCkK
IAkJYWxjX3NrdV9hdXRvbXV0ZShjb2RlYyk7CiB9CkBAIC0xNDY3Nyw2ICsxNDcxOSw4IEBAIHN0
YXRpYyB2b2lkIGFsYzY2Ml9hdXRvX2luaXRfYW5hbG9nX2lucHV0KHN0cnVjdCBoZGFfY29kZWMg
KmNvZGVjKQogCX0KIH0KIAorI2RlZmluZSBhbGM2NjJfYXV0b19pbml0X2lucHV0X3NyYyAgICAg
YWxjODgyX2F1dG9faW5pdF9pbnB1dF9zcmMKKwogc3RhdGljIGludCBhbGM2NjJfcGFyc2VfYXV0
b19jb25maWcoc3RydWN0IGhkYV9jb2RlYyAqY29kZWMpCiB7CiAJc3RydWN0IGFsY19zcGVjICpz
cGVjID0gY29kZWMtPnNwZWM7CkBAIC0xNDczMyw2ICsxNDc3Nyw3IEBAIHN0YXRpYyB2b2lkIGFs
YzY2Ml9hdXRvX2luaXQoc3RydWN0IGhkYV9jb2RlYyAqY29kZWMpCiAJYWxjNjYyX2F1dG9faW5p
dF9tdWx0aV9vdXQoY29kZWMpOwogCWFsYzY2Ml9hdXRvX2luaXRfaHBfb3V0KGNvZGVjKTsKIAlh
bGM2NjJfYXV0b19pbml0X2FuYWxvZ19pbnB1dChjb2RlYyk7CisJYWxjNjYyX2F1dG9faW5pdF9p
bnB1dF9zcmMoY29kZWMpOwogCWlmIChzcGVjLT51bnNvbF9ldmVudCkKIAkJYWxjX3NrdV9hdXRv
bXV0ZShjb2RlYyk7CiB9Cgo=
------=_Part_66627_5323877.1218837702892--
